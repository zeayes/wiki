#import "Rectangle.h"

@implementation Rectangle
-(void) calculateAreaOfLength: (float)length andBreadth: (float)breadth {
    area = length * breadth;
}

-(void) printArea {
    NSLog(@"The area of Rectangle is %f", area);
}
@end
