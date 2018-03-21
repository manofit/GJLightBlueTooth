//
//  GJUtil.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "GJUtil.h"

@implementation GJUtil

+ (UIButton *)createBtnWithFrame:(CGRect)frame Title:(NSString *)title Font:(CGFloat)font TitleColor:(UIColor *)titleColor BtnBackgroundColor:(UIColor *)bgColor Target:(id)target Action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    btn.backgroundColor = bgColor;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame Title:(NSString *)title Font:(CGFloat)font BackgroundColor:(UIColor *)bgColor TitleColor:(UIColor *)titleColor{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = titleColor;
    label.backgroundColor = bgColor;
    label.font = [UIFont systemFontOfSize:font];
    return label;
    
}

@end
