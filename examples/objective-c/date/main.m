#import <Foundation/Foundation.h>

int main(int argc, const char *argv[]) {

    @autoreleasepool {
        // formatter datetime
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
        [formatter setLocale:locale];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate *date = [formatter dateFromString:@"2014-01-10 13:42:14"];
        NSLog(@"date from string is: %@", date);

        NSDate *today = [NSDate date];
        NSString *dateString = [formatter stringFromDate:today];
        NSLog(@"today string is: %@", dateString);

        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24 * 60 * 60)];
        NSString *yesterdayString = [formatter stringFromDate:yesterday];
        NSLog(@"yesterday string is: %@", yesterdayString);

        NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:+(24 * 60 * 60)];
        NSString *tomorrowString = [formatter stringFromDate:tomorrow];
        NSLog(@"tomorrow string is: %@", tomorrowString);
    }

    return 0;
}
