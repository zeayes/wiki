package snowfake

import (
	"testing"
	"time"

	"github.com/samuel/go-zookeeper/zk"
)

var (
	timeout   = 3
	client    *zk.Conn
	namespace = "test"
	servers   = []string{"127.0.0.1:2181"}
)

func init() {
	var err error
	client, _, err = zk.Connect(servers, time.Duration(timeout)*time.Second)
	if err != nil {
		panic(err)
	}
}

func TestParseSnowFakeID(t *testing.T) {
	nowFunc = func() time.Time { return time.Now() }
	workerID := int64(1)
	worker := &Worker{workerID: workerID}
	seq := int64(1)
	timestamp := worker.getTimestamp()
	id := worker.makeSequence(timestamp, workerID, seq)
	ts, w, s := worker.parseSnowFakeID(id)
	if ts != timestamp || w != workerID || s != seq {
		t.Fatal("check snowfake id erorr")
	}
}

func TestGetID(t *testing.T) {
	gen, err := GetGenerator(namespace, client)
	if err != nil {
		t.Fatalf("GetGenerator error %v", err)
	}
	gen.GetID()
	gen.deletePaths()
}
