/*
 * A simple multi-thread tcp server which is runing forever.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUF_SIZE 512
#define BACKLOG 5
#define FEED_MSG "Thanks for your connection."

void *handler(void *arg);

int main(int argc, char *argv[]) {
    int listenfd, connfd;
    struct sockaddr_in serv_addr, cli_addr;
    socklen_t cli_len;
    pthread_t tid;

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

        pthread_create(&tid, NULL, &handler, (void *)&connfd);
    }

    close(listenfd);

    return 0;
}

void *handler(void *arg) {
    char buffer[BUF_SIZE];
    int nbytes;
    memset(buffer, 0, BUF_SIZE);
    int connfd = *(int *)arg;
    while ((nbytes = read(connfd, buffer, BUF_SIZE))) {
        if (nbytes < 0) {
            perror("ERROR: read");
            exit(1);
        }
        printf("message from client is: %s\n", buffer);
        nbytes = write(connfd, FEED_MSG, strlen(FEED_MSG));
        if (nbytes < 0) {
            perror("ERROR: write");
            exit(1);
        }
        memset(buffer, 0, BUF_SIZE);
    }
    return NULL;
}

