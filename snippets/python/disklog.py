# -*- coding: utf-8 -*-

import os
import time
import fcntl
import os.path
import datetime
import traceback
import simplejson

class MsgTypeRequiredError(Exception):
    pass

class DiskLog():

    def __init__(self, log_dir, server_ip, project_name, retry_count=3):
        self.log_dir = log_dir
        self.retry_count = retry_count
        self.server_ip = server_ip
        self.project_name = project_name

    def write(self, msg):
        if 'msg_type' not in msg.keys():
            raise MsgTypeRequiredError

        msg_type = msg['msg_type']
        abs_dir = os.path.join(self.log_dir, msg_type)
        if not os.path.exists(abs_dir):
            os.mkdir(abs_dir)
        today = datetime.datetime.now().strftime("%Y%m%d")
        filename = '_'.join([self.project_name, msg_type.lower(), self.server_ip,  today]) + '.txt'
        file_path = os.path.join(abs_dir, filename)
        for i in range(self.retry_count):
            try:
                file = open(file_path, "a")
                fcntl.flock(file, fcntl.LOCK_EX)
                file.write("{msg}\n".format(msg=simplejson.dumps(msg)))
                fcntl.flock(file, fcntl.LOCK_UN)
                file.close()
                break
            except:
                print traceback.print_exc()
                time.sleep(0.0001)


if __name__ == '__main__':
    import gevent

    def benchmark():
        data = {'msg_type': 'UserInfoLog', "user_id": 10, "username": "zeayes", "age": 20}
        log_dir = '.'
        server_ip = "127.0.0.1"
        project_name = "test"
        disklog = DiskLog(log_dir, server_ip, project_name)
        gevent.joinall([gevent.spawn(disklog.write, data) for i in range(2)])
    benchmark()
