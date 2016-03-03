//
//  LTGestureLockView.m
//  GestureLockDemo
//
//  Created by lkeg on 16/3/3.
//  Copyright © 2016年 lemon tree. All rights reserved.
//

#import "LTGestureLockView.h"
#import "LTGestureLockNodeView.h"

const NSInteger pointCount = 9;
const NSInteger rowCount = 3;
const CGFloat linespace = 40.0;

@interface LTGestureLockView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIBezierPath *polyline;
@property (nonatomic, strong) UIBezierPath *straight;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) CAShapeLayer *straightLayer;
@property (nonatomic, strong) CAShapeLayer *polyLayer;
@property (nonatomic, copy) NSMutableString *innerCode;
@property (nonatomic, strong) NSMutableArray<UIView<LTGestureLockNodeProtocol>*> *pointViews;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL endLock;
@end

@implementation LTGestureLockView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (UIColor *)innerHightlightColor {
    if (_hightlightColor) {
        return _hightlightColor;
    }
    return self.tintColor;
}

- (void)setHightlightColor:(UIColor *)hightlightColor {
    _hightlightColor = hightlightColor;
    _straightLayer.strokeColor = hightlightColor.CGColor;
    _polyLayer.strokeColor = hightlightColor.CGColor;
}

- (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;
    [self.pointViews enumerateObjectsUsingBlock:^(UIView<LTGestureLockNodeProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj highlight:NO color:defaultColor];
    }];
}

- (void)setUp {
    _pointViews = [[NSMutableArray alloc] initWithCapacity:pointCount];
    _innerCode = [[NSMutableString alloc] initWithCapacity:pointCount];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchMoving:)];
    _panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:_panGestureRecognizer];
    
    _polyline = [UIBezierPath bezierPath];
    _straight = [UIBezierPath bezierPath];
    [_straight moveToPoint:CGPointZero];
    _straightLayer = [CAShapeLayer layer];
    _straightLayer.path = _straight.CGPath;
    _straightLayer.fillColor = [UIColor clearColor].CGColor;
    _straightLayer.strokeColor = [self innerHightlightColor].CGColor;
    _straightLayer.lineWidth = 2;
    
    _polyLayer = [CAShapeLayer layer];
    _polyLayer.path = _polyline.CGPath;
    _polyLayer.fillColor = [UIColor clearColor].CGColor;
    _polyLayer.strokeColor = [self innerHightlightColor].CGColor;
    _polyLayer.lineWidth = 2;
    
    
    [self.layer addSublayer:_polyLayer];
    
    for (NSInteger i = 0; i < pointCount; i++) {
        UIView<LTGestureLockNodeProtocol> *view = [LTGestureLockNodeView new];
        view.tag = i;
        [_pointViews addObject:view];
        [self addSubview:view];
    }

}


- (void)touchMoving:(UIPanGestureRecognizer *)gesture {
    if (self.endLock) {
        return ;
    }
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            UIView<LTGestureLockNodeProtocol> *node = (UIView<LTGestureLockNodeProtocol> *)[self pointInView:point];
            if (node) {
                _lastPoint = node.center;
                [node highlight:YES color:[self innerHightlightColor]];
                [_polyline moveToPoint:node.center];
                [self.layer addSublayer:_polyLayer];
                [self.innerCode appendString:@(node.tag).stringValue];
                node.tag = NSIntegerMax;
                [self.layer addSublayer:_straightLayer];
            }
        }
            
            break;
        case UIGestureRecognizerStateChanged: {
            [_straight removeAllPoints];
            [_straight moveToPoint:_lastPoint];
            [_straight addLineToPoint:point];
            _straightLayer.path = _straight.CGPath;
            UIView<LTGestureLockNodeProtocol> *node = (UIView<LTGestureLockNodeProtocol> *)[self pointInView:point];
            if (node && node.tag != NSIntegerMax) {
                _lastPoint = node.center;
                [node highlight:YES color:[self innerHightlightColor]];
                [self.innerCode appendString:@(node.tag).stringValue];
                node.tag = NSIntegerMax;
                [_polyline addLineToPoint:node.center];
                _polyLayer.path = _polyline.CGPath;
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            [_straight removeAllPoints];
            !self.gestureCodeChanged ?: self.gestureCodeChanged(_innerCode);
            [_straightLayer removeFromSuperlayer];
            self.endLock = YES;
        }
        default:
            break;
    }
}

- (NSString *)code {
    return self.endLock ? [self.innerCode copy] :  @"" ;
}

- (void)resetCode {
    self.endLock = NO;
    _innerCode = [[NSMutableString alloc] initWithCapacity:pointCount];
    [self.polyline removeAllPoints];
    [self.straight removeAllPoints];
    self.polyLayer.path = NULL;
    self.straightLayer.path = NULL;
    [self.pointViews enumerateObjectsUsingBlock:^(UIView<LTGestureLockNodeProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = idx;
        [obj highlight:NO color:self.defaultColor];
    }];
}

- (UIView *)pointInView:(CGPoint) point {
    __block UIView *view = nil;
   view =  [self hitTest:point withEvent:nil];
    if (![view conformsToProtocol:@protocol(LTGestureLockNodeProtocol)]) {
        return nil;
    }
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.polyLayer.frame = self.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.lineWidth = 1.0f;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRect:self.bounds];
    maskLayer1.fillRule = kCAFillRuleEvenOdd;
    maskLayer1.lineWidth = 1.0f;
    maskLayer1.strokeColor = [UIColor blackColor].CGColor;
    maskLayer1.fillColor = [UIColor blackColor].CGColor;
    CGFloat totalWidth = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat width = ( totalWidth - (rowCount - 1) * linespace) / rowCount;
    CGFloat height = width;
    CGFloat x = 0;
    CGFloat y = 0;
    for (NSInteger i = 0; i < pointCount; i++) {
        UIView *obj = (UIView *)self.pointViews[i];
        if (i % rowCount == 0) {
            x = 0;
        }
        if (i && i % rowCount == 0) {
            y += height + linespace;
        }
        obj.frame = CGRectMake(x, y, width, height);
        x += width + linespace;
        [maskPath appendPath:[UIBezierPath bezierPathWithOvalInRect:obj.frame]];
        [maskPath1 appendPath:[UIBezierPath bezierPathWithOvalInRect:obj.frame]];
    }
    maskLayer.path = maskPath.CGPath;
    maskLayer1.path = maskPath1.CGPath;
    self.polyLayer.mask = maskLayer;
    self.straightLayer.mask = maskLayer1;
}

@end

