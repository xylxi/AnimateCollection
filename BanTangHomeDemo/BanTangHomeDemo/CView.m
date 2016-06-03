//
//  CView.m
//  TestTest
//
//  Created by WangZHW on 16/6/3.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import "CView.h"

@implementation CView

// 改变响应者
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint topPoint = [self convertPoint:point toView:self.topView];
    if ([self.topView pointInside:topPoint withEvent:event]) {
        NSInteger tag = self.scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width);
        UIView *v = self.arr[tag];
        return v;
    }
    return [super hitTest:point withEvent:event];
}


@end
