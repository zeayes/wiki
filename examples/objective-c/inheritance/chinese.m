#import "chinese.h"

@implementation Chinese

-(NSString *) getAddress {
    return [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.district];
}

@end
