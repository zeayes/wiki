#import "chinese.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Person *japanese = [[Person alloc] initWithFirstName:@"Jack" lastName:@"toyota"];
        NSString *des = [japanese getDescription];
        NSLog(@"Person's description is: %@", des);

        Chinese *lee = [[Chinese alloc] initWithFirstName:@"zeayes" lastName:@"lee"];
        lee.province = @"Guangdong";
        lee.city = @"shenzhen";
        lee.district = @"nanshan";
        NSString *description = [lee getDescription];
        NSLog(@"Chinese's description is: %@", description);
    }

    return 0;
}
