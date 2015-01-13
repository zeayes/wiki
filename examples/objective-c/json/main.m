#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSArray *people = @[
            @{@"name": @"John", @"age": @23, @"gender": @YES},
            @{@"name": @"Tom", @"age": @25, @"gender": @YES},
            @{@"name": @"Lucy", @"age": @20, @"gender": @NO},
        ];
        if ([NSJSONSerialization isValidJSONObject:people]) {
            NSError *error;
            NSData *data = [NSJSONSerialization dataWithJSONObject:people options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"json serialization string: %@", jsonString);

            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@", [json class]);
            if ([json isKindOfClass: [NSArray class]]) {
                NSDictionary *Tom = [(NSArray *)json objectAtIndex:1];
                NSLog(@"%@", Tom);
                BOOL gender = [[Tom objectForKey:@"gender"] boolValue];
                NSLog(@"Tom's gender: %@", gender ? @"YES": @"NO");
            }
        }
    }

    return 0;
}
