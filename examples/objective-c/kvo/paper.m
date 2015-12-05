#import "paper.h"

@implementation Paper
{
    Student *student;
}

- (id) init: (Student *) stu
{
    if (self = [super init]) {
        student = stu;
        [stu addObserver: self
              forKeyPath: @"course"
                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context: NULL
        ];
        [stu addObserver: self
              forKeyPath: @"age"
                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context: NULL
        ];
    }
    return self;
}

- (void) dealloc
{
    [student removeObserver: self forKeyPath: @"age"];
    [student removeObserver: self forKeyPath: @"course"];
}

- (void) observeValueForKeyPath: (NSString *) keyPath
                       ofObject: (id) object
                         change: (NSDictionary *) change
                        context: (void *)context
{
    if ([keyPath isEqualToString: @"course"]) {
        NSLog(@"course changed, new course is: %@, old course is: %@.",
                [change objectForKey: NSKeyValueChangeNewKey],
                [change objectForKey: NSKeyValueChangeOldKey]);
    } else if ([keyPath isEqualToString: @"age"]) {
        NSLog(@"age changed, new age is: %@, old age is: %@.",
                [change objectForKey: NSKeyValueChangeNewKey],
                [change objectForKey: NSKeyValueChangeOldKey]);
    }
}

@end
