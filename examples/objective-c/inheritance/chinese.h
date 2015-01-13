#import "person.h"

@interface Chinese: Person

@property NSString *province;
@property NSString *city;
@property NSString *district;

-(NSString *) getAddress;

@end
