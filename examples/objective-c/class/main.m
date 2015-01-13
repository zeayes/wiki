#import "person.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Person *zeayes = [[Person alloc] initWithFirstName:@"zeayes" lastName:@"lee"];
        NSString *fullName = [zeayes getFullName];
        NSLog(@"fullName is :%@", fullName);
    }

    return 0;
}
