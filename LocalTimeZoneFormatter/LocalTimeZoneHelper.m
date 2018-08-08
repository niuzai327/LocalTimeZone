//
//  LocalTimeZoneHelper.m
//  LocalTimeZone
//
//  Created by YXY on 2018/8/8.
//  Copyright © 2018年 YXY. All rights reserved.
//

#import "LocalTimeZoneHelper.h"

@implementation LocalTimeZoneHelper

+ (NSDateFormatter *)localTimeZoneFormatter{
    static NSDateFormatter *localDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localDateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSInteger gmtOffSet = [timeZone secondsFromGMTForDate:[NSDate date]];
        [localDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:gmtOffSet]];
        [localDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
        localDateFormatter.dateFormat = @"yyyyMMdd HH:mm";
    });
    return localDateFormatter;
}

+ (NSDateFormatter *)lenientFormatter{
    static NSDateFormatter *lenientFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lenientFormatter = [[NSDateFormatter alloc] init];
        lenientFormatter.dateFormat = @"yyyyMMdd";
        lenientFormatter.lenient = YES;
    });
    return lenientFormatter;
}

+ (NSDateFormatter *)offSetTimeZoneFormatter{
    static NSDateFormatter *offSetFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        offSetFormatter = [[NSDateFormatter alloc] init];
        offSetFormatter.dateFormat = @"yyyyMMdd";
        [offSetFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    });
    return offSetFormatter;
}

@end
