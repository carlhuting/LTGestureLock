//
//  LTGestureLockNodeView.h
//  GestureLockDemo
//
//  Created by lkeg on 16/3/3.
//  Copyright © 2016年 lemon tree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTGestureLockNodeProtocol <NSObject>
- (void)highlight:(BOOL) highlight color:(UIColor *)color;
@end

@interface LTGestureLockNodeView : UIView <LTGestureLockNodeProtocol>
- (void)highlight:(BOOL) highlight color:(UIColor *)color;
@end
