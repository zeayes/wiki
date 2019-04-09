package snowfake

import (
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/samuel/go-zookeeper/zk"
)

const (
	baseEpoch      = 1554187183161
	timestampBits  = 42
	workerIDBits   = 9
	sequenceBits   = 12
	workerIDShift  = sequenceBits
	timestampShift = sequenceBits + workerIDBits
	sequenceMask   = -1 ^ (-1 << sequenceBits)
	maxTimestamp   = 1 << timestampBits
	maxWorkerID    = 1 << workerIDBits
	maxSequenceID  = 1 << sequenceBits

	lockPrefix = "/_snowfake_/locks"
	pathPrefix = "/_snowfake_/paths"
)

var (
	nowFunc     = time.Now
	mutex       sync.Mutex
	snowFakeMap = make(map[string]*SnowFake)
)

type int64Slice []int64

func (s int64Slice) Len() int           { return len(s) }
func (s int64Slice) Swap(i, j int)      { s[i], s[j] = s[j], s[i] }
func (s int64Slice) Less(i, j int) bool { return s[i] < s[j] }

// Worker 根据twitter的snowfake算法生成单调递增ID的具体worker
type Worker struct {
	sync.RWMutex
	workerID      int64
	lastSequence  int64
	lastTimestamp int64
}

func (s *Worker) getTimestamp() int64 {
	return nowFunc().UnixNano() / int64(time.Millisecond)
}

func (s *Worker) getMaxTimestamp() time.Time {
	return time.Unix((maxTimestamp-1+baseEpoch)/1000, 0)
}

func (s *Worker) getMaxID() int64 {
	return s.makeSequence(maxTimestamp, maxWorkerID, maxSequenceID)
}

func (s *Worker) makeSequence(timestamp, workerID, sequence int64) int64 {
	return (timestamp-baseEpoch)<<timestampShift | (workerID << workerIDShift) | sequence
}

func (s *Worker) parseSnowFakeID(id int64) (int64, int64, int64) {
	sequence := id & (maxSequenceID - 1)
	workerID := (id >> workerIDShift) & (maxWorkerID - 1)
	timestamp := (id >> timestampShift) & (maxTimestamp - 1)
	return timestamp + baseEpoch, workerID, sequence
}

func (s *Worker) nextID() int64 {
	for {
		timestamp := s.getTimestamp()
		s.Lock()
		sequence := (s.lastSequence + 1) & sequenceMask
		// 如果sequence超过限制，需要等待1毫秒重试;这个地方未考虑服务器时间回拨的情况
		if timestamp == s.lastTimestamp && sequence <= s.lastSequence {
			time.Sleep(time.Millisecond)
			continue
		}
		s.lastSequence = sequence
		s.lastTimestamp = timestamp
		s.Unlock()
		return s.makeSequence(timestamp, s.workerID, sequence)
	}
}

// SnowFake 可以生成分布式ID的实例，参考twitter的snowfake算法。
type SnowFake struct {
	nodePath string
	lockPath string
	client   *zk.Conn
	lock     *zk.Lock
	worker   *Worker
}

func (s *SnowFake) ensurePaths() error {
	for _, path := range []string{s.nodePath, s.lockPath} {
		paths := strings.Split(path, "/")
		for i := 2; i < len(paths)+1; i++ {
			p := strings.Join(paths[:i], "/")
			_, err := s.client.Create(p, []byte{}, 0, zk.WorldACL(zk.PermAll))
			if err != nil && err != zk.ErrNodeExists {
				return err
			}
		}
	}
	s.lock = zk.NewLock(s.client, s.lockPath, zk.WorldACL(zk.PermAll))
	return nil
}

func (s *SnowFake) deletePaths() error {
	for _, path := range []string{s.nodePath, s.lockPath} {
		if err := s.client.Delete(path, -1); err != nil {
			return err
		}
	}
	return nil
}

func (s *SnowFake) getWorkerID() (int64, error) {
	if err := s.ensurePaths(); err != nil {
		return 0, err
	}
	if err := s.lock.Lock(); err != nil {
		return 0, err
	}
	defer s.lock.Unlock()
	children, _, err := s.client.Children(s.nodePath)
	if err != nil {
		return 0, err
	}
	workerID := int64(1)
	count := len(children)
	if count > 0 {
		workerIDs := make(int64Slice, 0, count)
		for _, child := range children {
			id, err := strconv.ParseInt(child, 10, 64)
			if err != nil {
				return 0, err
			}
			workerIDs = append(workerIDs, id)
		}
		sort.Sort(workerIDs)
		// 现有的workerID 没有超过限制，在现有的workerID上加1
		if workerIDs[count-1] < maxWorkerID-1 {
			workerID = workerIDs[count-1] + 1
		} else {
			for i := int64(0); i < workerIDs[count-1]+1; i++ {
				if i+1 != workerIDs[count-1] {
					workerID = i + 1
					break
				} else if i == int64(count)-1 {
					workerID = i + 2
					break
				} else if workerIDs[i] != workerIDs[i+1]-1 {
					workerID = workerIDs[i] + 1
					break
				}
			}
		}
	}
	workerPath := s.nodePath + "/" + strconv.FormatInt(workerID, 10)
	if _, err := s.client.Create(workerPath, []byte{}, zk.FlagEphemeral, zk.WorldACL(zk.PermAll)); err != nil {
		panic(err)
	}
	return workerID, nil
}

// GetID 获取一个分布式ID
func (s *SnowFake) GetID() int64 {
	return s.worker.nextID()
}

// GetGenerator 通过namespace获取一个全局的ID生成器
func GetGenerator(namespace string, client *zk.Conn) (*SnowFake, error) {
	mutex.Lock()
	defer mutex.Unlock()
	if sf, ok := snowFakeMap[namespace]; ok {
		return sf, nil
	}
	sf := &SnowFake{
		client:   client,
		nodePath: pathPrefix + "/" + namespace,
		lockPath: lockPrefix + "/" + namespace,
	}
	workerID, err := sf.getWorkerID()
	if err != nil {
		return nil, err
	}
	sf.worker = &Worker{workerID: workerID}
	return sf, nil
}
