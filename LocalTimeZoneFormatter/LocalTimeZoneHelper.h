//
//  LocalTimeZoneHelper.h
//  LocalTimeZone
//
//  Created by YXY on 2018/8/8.
//  Copyright © 2018年 YXY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTimeZoneHelper : NSDateFormatter

+ (NSDateFormatter *)localTimeZoneFormatter;

+ (NSDateFormatter *)lenientFormatter;

+ (NSDateFormatter *)offSetTimeZoneFormatter;

@end
