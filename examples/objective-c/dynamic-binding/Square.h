#import <Foundation/Foundation.h>

@interface Square : NSObject
{
    float area;
}

- (void)calculateAreaOfSide: (float)side;
- (void)printArea;
@end
