#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSError *error;
        // GET
        NSURL *getURL = [NSURL URLWithString: @"http://127.0.0.1:6100/user/10001/profile/"];
        NSURLRequest *getRequest = [[NSURLRequest alloc] initWithURL:getURL
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval: 10];
        NSData *data = [NSURLConnection sendSynchronousRequest:getRequest
                                             returningResponse:nil
                                                         error:&error
        ];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error
        ];
        NSLog(@"json data: %@", json);

        // POST
        NSURL *postURL = [NSURL URLWithString: @"http://127.0.0.1:6100/user/query/"];
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL:postURL];
        NSDictionary *args = @{@"type": @"username", @"value": @"zeayes"};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error
        ];
        [postRequest setHTTPMethod:@"POST"];
        [postRequest setHTTPBody: jsonData];
        [postRequest setValue: @"applicaton/json" forHTTPHeaderField:@"Content-Type"];
        [postRequest setTimeoutInterval:[@10 doubleValue]];
        NSData *response = [NSURLConnection sendSynchronousRequest:postRequest
                                                 returningResponse:nil
                                                             error:&error
        ];
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:response
                                                                     options:kNilOptions
                                                                       error:&error
        ];
        NSLog(@"json data: %@", responseJson);

    }

    return 0;
}
