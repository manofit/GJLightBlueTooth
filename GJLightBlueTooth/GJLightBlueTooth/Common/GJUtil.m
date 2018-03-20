//
//  GJUtil.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "GJUtil.h"

@implementation GJUtil

+ (UIButton *)createBtnWithFrame:(CGRect)frame Title:(NSString *)title Font:(CGFloat)font BtnBackgroundColor:(UIColor *)bgColor CornerRadius:(CGFloat)radius{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.titleLabel.text = title;
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = radius;
    return btn;
    
}

@end
