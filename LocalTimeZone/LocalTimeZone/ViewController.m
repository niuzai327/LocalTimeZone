//
//  ViewController.m
//  LocalTimeZone
//
//  Created by YXY on 2018/8/8.
//  Copyright © 2018年 YXY. All rights reserved.
//

#import "ViewController.h"
#import "LocalTimeZoneHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDateFormatter *dateFormatter = [LocalTimeZoneHelper offSetTimeZoneFormatter];
    NSDate *date = [dateFormatter dateFromString:@"19860504"];
    NSLog(@"date %@",date);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
