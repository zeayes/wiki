#import "chinese.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Chinese *lee = [[Chinese alloc] initWithFirstName:@"三" lastName:@"李"];
        lee.province = @"广东省";
        lee.city = @"深圳市";
        lee.district = @"南山区";
        NSString *address = [lee getAddress];
        NSLog(@"address is: %@", address);
    }

    return 0;
}
