//
//  LTGestureLockNodeView.m
//  GestureLockDemo
//
//  Created by lkeg on 16/3/3.
//  Copyright © 2016年 lemon tree. All rights reserved.
//

#import "LTGestureLockNodeView.h"

@interface LTGestureLockNodeView ()
@property (nonatomic, strong) CAShapeLayer *centerShaper;
@end

@implementation LTGestureLockNodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 2.0;
        _centerShaper = [CAShapeLayer layer];
    }
    return self;
}

- (void)highlight:(BOOL)highlight color:(UIColor *)color{
    self.layer.borderColor = color.CGColor;
    if (highlight) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        [path addArcWithCenter:center radius:10 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        self.centerShaper.fillColor = color.CGColor;
        self.centerShaper.path = path.CGPath;
        [self.layer addSublayer:_centerShaper];
    } else {
        [_centerShaper removeFromSuperlayer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
}


@end
