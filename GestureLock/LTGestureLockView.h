//
//  LTGestureLockView.h
//  GestureLockDemo
//
//  Created by lkeg on 16/3/3.
//  Copyright © 2016年 lemon tree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureCodeChanged)(NSString *code);

@interface LTGestureLockView : UIView
@property (nonatomic, copy) GestureCodeChanged gestureCodeChanged;
@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, strong) UIColor *hightlightColor;
@property (nonatomic, strong) UIColor *defaultColor;
- (void)resetCode;
@end
