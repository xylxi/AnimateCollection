//
//  ViewController.m
//  SLExploreRunLoop SLRunLoopPerformance
//
//  Created by WangZHW on 16/6/8.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import "ViewController.h"
#import "MonitorController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MonitorController sharedInstance] startMonitor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int count = 0 ;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    sleep(10);
    NSLog(@"\n\n\n");
    count++;
}


@end
