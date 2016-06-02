//
//  SLMusicPlayLoadView.h
//  SLMusicPlayLoadView
//
//  Created by WangZHW on 16/5/31.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLMusicPlayLoadView : UIView

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new  UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFrame:(CGRect )frame;
- (void)start;
- (void)stop;

@end
