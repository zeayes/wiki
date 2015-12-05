#import "sender.h"
#import "reciever.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Reciever *reciever = [[Reciever alloc] init];
        [reciever recieve];

        Sender *sender = [[Sender alloc] init];
        [sender broadcast];
    }

    return 0;
}
