//
//  JBSlider.h
//  LiShiLight-OC
//
//  Created by Bob on 16/11/10.
//  Copyright © 2016年 HaiHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBSlider;
@protocol JBSliderDelegate <NSObject>

- (void)JBSlider:(JBSlider *)slider didChangeValue:(CGFloat )value;

@end


@interface JBSlider : UIView

@property (nonatomic, assign) CGFloat beginValue;//默认0

@property (nonatomic, assign) CGFloat endValue;//默认1

@property (nonatomic, retain) NSArray *backgroundColorArr;//用CGColor 如  @[(id)[UIColor redColor].CGColor];默认红色

@property (nonatomic, retain) UIImage *touchBarImage;//默认白色圆点

@property (nonatomic, retain) UIColor *numColor;//默认白色

@property (nonatomic, assign) CGFloat lineWidth; //默认为1.0

@property (nonatomic, assign) CGFloat currentValue;//默认0


@property (nonatomic, assign) id<JBSliderDelegate>delegate;

- (instancetype )initWithFrame:(CGRect)frame;//初始化方法

@end
