//
//  Cup.m
//  AnimateNumber
//
//  Created by zhoushengjian on 17/2/13.
//  Copyright © 2017年 zhoushengjian. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (nonatomic, weak) UIColor *color;

@end

@implementation CustomView

+ (instancetype)viewWithColor:(UIColor *)color {
    CustomView *cup = [[CustomView alloc] init];
    cup.color = color;
    
    return cup;
}

@end
