socket programming in c language.
=======

1. server with multi-processes
```sh
make
# 多进程
./multi_process_server 5555
./client 127.0.0.1 5555
# 多线程
./multi_thread_server 5556
./client 127.0.0.1 5556
make clean
```
