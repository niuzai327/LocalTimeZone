# LocalTimeZone
iOS夏令时问题
====
时间为nil问题
--------------
``` Objective-c
//校验生日日期是否正确
NSString *dateString = [trimStr substringWithRange:NSMakeRange(6, 8)];
NSDate *date = [[PMSDateFormatterHelper yyyyMMdd] dateFromString:dateString];
if (!date) {
   return NO;
}

+ (NSDateFormatter *)yyyyMMdd
{
    static NSDateFormatter *yyyyMMdd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yyyyMMdd = [[NSDateFormatter alloc] init];
        [yyyyMMdd setDateFormat:@"yyyyMMdd"];
    });
    return yyyyMMdd;
}
```
#打断点发现date为nil

然后自测19880409和19880411都没有问题，19880410特殊日期？

经查询1988年04月10日中国实行夏令时

先补充下知识“夏令时”

>夏时制，夏时令（Daylight Saving Time：DST），又称“日光节约时制”和“夏令时间”，是一种为节约能源而人为规定地方时间的制度，在这一制度实行期间所采用的统一时间称为“夏令时间”。一般在天亮早的夏季人为将时间调快一小时，可以使人早起早睡，减少照明量，以充分利用光照资源，从而节约照明用电。各个采纳夏时制的国家具体规定不同。目前全世界有近110个国家每年要实行夏令时。

>1986年4月，中国中央有关部门发出“在全国范围内实行夏时制的通知”，具体作法是：每年从四月中旬第一个星期日的凌晨2时整（北京时间），将时钟拨快一小时，即将表针由2时拨至3时，夏令时开始；到九月中旬第一个星期日的凌晨2时整（北京夏令时），再将时钟拨回一小时，即将表针由2时拨至1时，夏令时结束。从1986年到1991年的六个年度，除1986年因是实行夏时制的第一年，从5月4日开始到9月14日结束外，其它年份均按规定的时段施行。在夏令时开始和结束前几天，新闻媒体均刊登有关部门的通告。1992年起，夏令时暂停实行。

>实行时间
1986年至1991年，每年四月的第2个星期日早上2点，到九月的第2个夏令时钟表雕塑星期日早上2点之间。
1986年5月4日至9月14日（1986年因是实行夏令时的第一年，从5月4日开始到9月14日结束）
1987年4月12日至9月13日；
1988年4月10日至9月11日；
1989年4月16日至9月17日；
1990年4月15日至9月16日；
1991年4月14日至9月15日。

验证下夏令时在iOS系统中的时间段

```Objective-c
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd HH:mm"];
//    dateFormatter.lenient = YES;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSArray *dateArray = [NSArray arrayWithObjects:@"19880409 23:59",@"19880410 00:00",@"19880910 22:59", @"19880911 00:00", nil];
    for (NSString *str in dateArray) {
        NSLog(@"%@ formatter date: %@",str,[dateFormatter dateFromString:str]);
    }
```
![](https://github.com/niuzai327/LocalTimeZone/blob/master/Resources/clip.png)

发现问题了，19880410 00:00是不存在的，所以会初始化为nil
测试下
``` Objective-c
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSArray *dateArray = [NSArray arrayWithObjects:@"19860504",@"19860914",@"19870412",@"19870913",@"19880410",@"19880911",@"19890416",@"19890917",@"19900415",@"19900916",@"19910414",@"19910915", nil];
    for (NSString *str in dateArray) {
        NSLog(@"%@ formatter date: %@",str,[dateFormatter dateFromString:str]);
    }
```
打印结果如下：
![](https://github.com/niuzai327/LocalTimeZone/blob/master/Resources/clip2.png)

发现进入夏令时的时间转换NSDate都为nil
#解决方案
>1)给dateFormatter显示设置时区偏移量
```Objective-c
[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*8]];
```
>2)
>>a.仅仅是中国就有这么多时间，世界上很多的国家， 有的国家实行了夏令时，有的没有实行，如果每个国家都去单独处理的话，估计要把人累死，而且难以保证数据的准确性。有没有更好的办法去处理呢，网上搜索了一下formatter.lenient = YES; 就可以了，网上没有太多的解释，经过自己的分析，这个应该是允许如果时间不存在的话，可以获取距离最近的整点时间。
```Objective-c
dateFormatter.lenient = YES;
```
>>b.如果APP需要多个时区使用那么写死3600*8就不那么完美了.我们都知道3600*8是目标时区与GMT时区相差的秒数而已,那么动态计算出来这个Offset秒数即可.
```Objective-c
/设置转换后的目标日期时区
NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
//转换后源日期与世界标准时间的偏移量
NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];

NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
dateFormatter.dateFormat = @"yyyy-MM-dd";
[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset]];
NSDate *date0 = [dateFormatter dateFromString:@"1988-04-10"];
NSLog(@"timeZoneForSecondsFromGMT:%@", date0);
```


