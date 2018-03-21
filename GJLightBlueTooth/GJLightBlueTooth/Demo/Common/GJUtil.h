//
//  GJUtil.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GJUtil : NSObject

+ (UIButton *)createBtnWithFrame:(CGRect)frame Title:(NSString *)title Font:(CGFloat)font TitleColor:(UIColor *)titleColor BtnBackgroundColor:(UIColor *)bgColor Target:(id)target Action:(SEL)action;

+ (UILabel *)createLabelWithFrame:(CGRect)frame Title:(NSString *)title Font:(CGFloat)font BackgroundColor:(UIColor *)bgColor TitleColor:(UIColor *)titleColor;


@end
