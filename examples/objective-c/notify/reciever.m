#import "reciever.h"

@implementation Reciever

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) recieve
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handle:)
                                                 name: @"channel"
                                               object: nil];
}

- (void) handle: (NSNotification *) notify
{
    NSLog(@"recieve message is: %@", notify);
}


@end
