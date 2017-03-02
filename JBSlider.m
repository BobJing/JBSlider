//
//  JBSlider.m
//  LiShiLight-OC
//
//  Created by Bob on 16/11/10.
//  Copyright © 2016年 HaiHong. All rights reserved.
//

#import "JBSlider.h"

@interface JBSlider()
@property (nonatomic, retain) CAGradientLayer *lineLayer;
@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *rightLabel;
@property (nonatomic, retain) UIImageView *touchBar;
@end

@implementation JBSlider

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}
- (instancetype )initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    if (self.frame.size.width<100) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 100, self.frame.size.height);
    }
    if (self.frame.size.height<25) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 25);
    }

    self.backgroundColor = [UIColor clearColor];
    self.lineWidth = 1.0;
    self.numColor = [UIColor whiteColor];
    self.backgroundColorArr = @[(id)[UIColor redColor].CGColor,(id)[UIColor redColor].CGColor];
    self.beginValue = 0.0;
    self.endValue = 1.0;
    _currentValue = 0;

}

- (void)panAction:(UIPanGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    CGFloat offSet;//0到1
    if (point.x<45) {
        offSet = 0;
        point = CGPointMake(45, point.y);
    }
    else if (point.x>self.frame.size.width-45) {
        offSet = 1;
        point = CGPointMake(self.frame.size.width-45, point.y);
    }
    else{
        offSet = (point.x - 45)/self.lineLayer.frame.size.width;
    }
    self.touchBar.center = CGPointMake(point.x, self.touchBar.center.y);
    if (tap.state == 3) {
        _currentValue = self.beginValue + (self.endValue - self.beginValue)*offSet;
        NSLog(@"%f",self.currentValue);
        if ([_delegate respondsToSelector:@selector(JBSlider:didChangeValue:)]) {
            [_delegate JBSlider:self didChangeValue:self.currentValue];

        }
    }
}


- (void)drawRect:(CGRect)rect
{
    _lineLayer = [CAGradientLayer layer];
    [self.layer addSublayer:_lineLayer];
    _lineLayer.startPoint = CGPointMake(0, 0);
    _lineLayer.endPoint = CGPointMake(1, 0);
    _lineLayer.colors = self.backgroundColorArr;
    _lineLayer.frame = CGRectMake(45, rect.size.height/2.0 - self.lineWidth / 2.0, rect.size.width - 90, self.lineWidth);

    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  rect.size.height/2.0 - 10, 30, 20)];
    _leftLabel.textColor = self.numColor;
    _leftLabel.text = [NSString stringWithFormat:@"%.0f",_beginValue];
    _leftLabel.font = [UIFont systemFontOfSize:13];
    _leftLabel.adjustsFontSizeToFitWidth = YES;
    _leftLabel.textAlignment = 2;
    [self addSubview:_leftLabel];


    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(rect.size.width - 30,  rect.size.height/2.0 - 10, 30, 20)];
    _rightLabel.textColor = self.numColor;
    _rightLabel.text = [NSString stringWithFormat:@"%.0f",_endValue];
    _rightLabel.font = [UIFont systemFontOfSize:13];
    _rightLabel.adjustsFontSizeToFitWidth = YES;
    _rightLabel.textAlignment = 0;
    [self addSubview:_rightLabel];


    _touchBar = [[UIImageView alloc]init];
    if (self.touchBarImage) {
        _touchBar.image = self.touchBarImage;
        _touchBar.backgroundColor = [UIColor clearColor];
        _touchBar.contentMode = UIViewContentModeScaleAspectFit;
    }else
        {
        _touchBar.backgroundColor = [UIColor whiteColor];
        _touchBar.clipsToBounds = YES;
        _touchBar.layer.cornerRadius = 14;
        }
    _touchBar.bounds = CGRectMake(0, 0, 28, 28);
    CGFloat offSet = (self.frame.size.width-90)*_currentValue/(self.endValue - self.beginValue);
    _touchBar.center = CGPointMake(offSet + 45, self.frame.size.height/2.0);
    _touchBar.userInteractionEnabled = YES;
    [self addSubview:_touchBar];

    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [_touchBar addGestureRecognizer:tap];
}

- (void)setCurrentValue:(CGFloat)currentValue
{
    _currentValue = currentValue;
    if (currentValue>self.endValue) {
        _currentValue = self.endValue;
    }
    if (currentValue < self.beginValue) {
        _currentValue = self.beginValue;
    }
    CGFloat offSet = (self.frame.size.width-90)*_currentValue/(self.endValue - self.beginValue);
    __weak JBSlider *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.touchBar.center = CGPointMake(offSet + 45, self.touchBar.center.y);
    }];

}


@end
