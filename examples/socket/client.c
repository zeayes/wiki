/*
 * A simple tcp client.
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

int main(int argc, char *argv[]) {
    int sockfd, nbytes;
    struct sockaddr_in serv_addr;
    char send_buffer[BUF_SIZE], recv_buffer[BUF_SIZE];

    if (argc != 3) {
        fprintf(stderr, "USAGE: %s ip port\n", argv[1]);
        exit(1);
    }

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("ERROR: socket");
        exit(1);
    }

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr(argv[1]);
    serv_addr.sin_port = htons(atoi(argv[2]));

    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("ERROR: connect");
        exit(1);
    }

    memset(send_buffer, 0, BUF_SIZE);
    while(fgets(send_buffer, BUF_SIZE, stdin) != NULL) {
        nbytes = write(sockfd, send_buffer, strlen(send_buffer));
        if (nbytes < 0) {
            perror("ERROR: write");
            exit(1);
        }
        memset(recv_buffer, 0, BUF_SIZE);
        nbytes = read(sockfd, recv_buffer, BUF_SIZE);
        if (nbytes < 0) {
            perror("ERROR: read");
            exit(1);
        }
        printf("receive from server message is: %s\n", recv_buffer);
    }

    close(sockfd);

    return 0;
}
