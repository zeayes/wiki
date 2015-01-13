#import "person+nation.h"

@implementation Person (Nation)

-(NSString *) getPersonInfo {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
