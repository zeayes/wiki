#import "paper.h"
#import "student.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Student *student = [[Student alloc] init];
        student.name = @"Jhon";
        student.course = @"english";
        student.age = 10;
        NSLog(@"before changed, student course: %@, age: %d.", student.course, student.age);
        Paper *paper = [[Paper alloc] init: student];
        student.course = @"computer";
        student.age = 12;
        NSLog(@"after changed, student course: %@, age: %d.", student.course, student.age);
    }

    return 0;
}
