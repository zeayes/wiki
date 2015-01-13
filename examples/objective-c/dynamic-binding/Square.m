#import "Square.h"

@implementation Square

-(void) calculateAreaOfSide: (float)side {
    area = side * side;
}

-(void) printArea {
    NSLog(@"The area of square is %f", area);
}
@end
