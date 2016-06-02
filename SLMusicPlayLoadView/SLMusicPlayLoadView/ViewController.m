//
//  ViewController.m
//  SLMusicPlayLoadView
//
//  Created by WangZHW on 16/5/31.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import "ViewController.h"
#import "SLMusicPlayLoadView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SLMusicPlayLoadView *v = [[SLMusicPlayLoadView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [v start];
    [self.view addSubview:v];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v stop];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v start];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
