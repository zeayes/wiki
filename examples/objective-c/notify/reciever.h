#import <Foundation/Foundation.h>

@interface Reciever : NSObject

- (void) recieve;
- (void) handle: (NSNotification *) notify;

@end
