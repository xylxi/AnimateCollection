//
//  MonitorController.h
//  SLExploreRunLoop SLRunLoopPerformance
//
//  Created by WangZHW on 16/6/8.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonitorController : NSObject
+ (instancetype)sharedInstance;
- (void)startMonitor;
- (void)endMonitor;
- (void)printLogTrace;
@end
