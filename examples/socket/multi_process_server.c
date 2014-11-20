/*
 * A simple multi-processes tcp server which is runing forever.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUF_SIZE 512
#define BACKLOG 5
#define FEED_MSG "Thanks for your connection."


int main(int argc, char *argv[]) {
    int listenfd, connfd, nbytes;
    struct sockaddr_in serv_addr, cli_addr;
    socklen_t cli_len;
    char buffer[BUF_SIZE];
    pid_t pid;

    if (argc < 2) {
        fprintf(stderr, "USAGE: %s port\n", argv[0]);
        exit(0);
    }

    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    if (listenfd < 0) {
        perror("ERROR: socket");
        exit(1);
    }

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(atoi(argv[1]));

    if (bind(listenfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("ERROR: bind");
        exit(1);
    }
    if (listen(listenfd, BACKLOG) < 0) {
        perror("ERROR: listen");
        exit(1);
    }

    cli_len = sizeof(cli_addr);
    while((connfd = accept(listenfd, (struct sockaddr *)&cli_addr, &cli_len))) {
        if (connfd < 0) {
            perror("ERROR: connect");
            continue;
        }

        if ((pid = fork()) < 0) {
            perror("ERROR: fork");
            exit(1);
        } else if (pid == 0) { /* child process */
            memset(buffer, 0, BUF_SIZE);
            while((nbytes = read(connfd, buffer, BUF_SIZE))) {
                if (nbytes < 0) {
                    perror("ERROR: read");
                    exit(1);
                }
                printf("process(%d) receives message from client(%s:%d) is: %s.", 
                        getpid(), inet_ntoa(cli_addr.sin_addr), cli_addr.sin_port, buffer);
                nbytes = write(connfd, FEED_MSG, strlen(FEED_MSG));
                if (nbytes < 0) {
                    perror("ERROR: write");
                    exit(1);
                }
                memset(buffer, 0, BUF_SIZE);
            }
        }
        close(connfd);
    }

    close(listenfd);

    return 0;
}
