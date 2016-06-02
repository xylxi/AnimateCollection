//
//  SLMusicPlayLoadView.m
//  SLMusicPlayLoadView
//
//  Created by WangZHW on 16/5/31.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import "SLMusicPlayLoadView.h"


@interface SLMusicPlayLoadView (){
    CGRect    _frame;
    NSInteger _count;
    NSMutableArray *_layers;
    NSMutableArray *_strokes;
}

@end

@implementation SLMusicPlayLoadView

- (instancetype)initWithFrame:(CGRect )frame{
    _frame        = CGRectMake(0, 0, 40, 36);
    _frame.origin = frame.origin;
    self  = [super initWithFrame:_frame];
    if (self) {
        _count = 4;
        _layers = [NSMutableArray arrayWithCapacity:_count];
        _strokes = [NSMutableArray arrayWithObjects:@(0.5),(@0.9),@(1.0),@(0.4),@(0.3),@(0.8),@(0.7),@(0.2), nil];
        CGFloat margin = 5;
        CGFloat width  = 2;
        CGFloat space  = ( _frame.size.height - 2 * margin ) / (_count - 1);
        for (int i = 0 ; i < _count ; i++) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path  = [UIBezierPath bezierPath];
            CGFloat x           = margin + space * i;
            CGFloat y           = _frame.size.height - margin;
            [path moveToPoint:CGPointMake(x, y)];
            y                   = margin;
            [path addLineToPoint:CGPointMake(x, y)];
            
            layer.path = path.CGPath;
            layer.lineWidth = width;
            layer.lineCap   = kCALineCapSquare;
            layer.fillColor = [UIColor whiteColor].CGColor;
            layer.strokeColor = [UIColor whiteColor].CGColor;
            layer.strokeStart = 0.0;
            layer.strokeEnd   = 1.0;
            [self.layer addSublayer:layer];
            
            [_layers addObject:layer];
        }
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)start {
    for (int i = 0; i < _count; i++) {
        NSNumber *start  = _strokes[i * 2];
        NSNumber  *end   = _strokes[i * 2 + 1];
        CAShapeLayer *layer = _layers[i];
        layer.strokeEnd     = [start floatValue];
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        if (i == 0 || i == _count - 1) {
            basic.beginTime = CACurrentMediaTime() + i * 0.1;
        }else {
            basic.beginTime = CACurrentMediaTime() ;
        }
        basic.fromValue = start;
        basic.toValue   = end;
        basic.duration  = 0.5f;
        basic.autoreverses = YES;
        basic.repeatCount = FLT_MAX;
        basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [layer addAnimation:basic forKey:@"basic"];
    }
}

- (void)stop {
    for (int i = 0 ; i < _count; i++) {
        CAShapeLayer *layer = _layers[i];
        [layer removeAnimationForKey:@"basic"];
    }
}

@end
