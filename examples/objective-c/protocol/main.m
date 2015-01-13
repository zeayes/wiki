#import "coder.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Coder *coder = [[Coder alloc] init];
        [coder programming];
        
        if ([coder conformsToProtocol:@protocol(Program)]) {
            [coder programming];
        }
    }

    return 0;
}
