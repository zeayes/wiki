#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *course;
@property (nonatomic) int age;

- (void) changeCourse: (NSString *) newCourse;

@end
