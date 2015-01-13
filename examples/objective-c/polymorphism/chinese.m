#import "chinese.h"

@implementation Chinese

-(NSString *) getDescription {
    return [NSString stringWithFormat:@"%@ %@ lives in %@ %@ %@", self.firstName, self.lastName, self.province, self.city, self.district];
}

@end
