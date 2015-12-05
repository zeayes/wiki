#import "sender.h"

@implementation Sender

- (void) broadcast
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys: @"id", 1, @"name", @"Jason", nil];
    [nc postNotificationName: @"channel" object: self userInfo: message];
}

@end
