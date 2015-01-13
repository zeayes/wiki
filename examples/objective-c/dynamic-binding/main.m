#import "Rectangle.h"

int main(int argc, char *argv[]) {
    Square *square = [[Square alloc]init];
    [square calculateAreaOfSide:10.0];

    Rectangle *rectangle = [[Rectangle alloc]init];
    [rectangle calculateAreaOfLength: 10.0 andBreadth:5.0];

    NSArray *shapes = [[NSArray alloc]initWithObjects: square, rectangle, nil];

    id  object1 = [shapes objectAtIndex:0];
    [object1 printArea];
    id object2 = [shapes objectAtIndex:1];
    [object2 printArea];

    return 0;
}
