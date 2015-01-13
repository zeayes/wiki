#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        double (^speed)(double distance, double duration);

        speed = ^double(double distance, double duration) {
            return distance / duration;
        };

        double sd =  speed(100, 10);
        NSLog(@"The car is running at speed: %f", sd);
    }

    return 0;
}
