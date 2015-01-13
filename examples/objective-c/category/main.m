#import "person+nation.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Person *lee = [[Person alloc] initWithFirstName:@"zeayes" lastName:@"lee"];
        NSString *info = [lee getPersonInfo];
        NSLog(@"person info is: %@", info);
    }

    return 0;
}
