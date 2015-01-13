#import "person.h"

@implementation Person

-(NSString *) getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

-(id) initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
    }
    return self;
}

@end
