//
//  ViewController.m
//  GestureLockDemo
//
//  Created by lkeg on 16/3/3.
//  Copyright © 2016年 lemon tree. All rights reserved.
//

#import "ViewController.h"
#import "LTGestureLockView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet LTGestureLockView *gestureLockView;

@end

@implementation ViewController
- (IBAction)resetCodeTapped:(id)sender {
    [self.gestureLockView resetCode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gestureLockView.hightlightColor = [UIColor orangeColor];
    self.gestureLockView.defaultColor = [UIColor grayColor];
    GestureCodeChanged block = ^(NSString *code) {
        NSLog(@"password %@", code);
    };
    self.gestureLockView.gestureCodeChanged = [block copy];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
