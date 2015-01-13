#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    NSNumber *age;
}
    
@property BOOL gender;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

-(id) initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(NSString *) getFullName;

@end
