//
//  GJLBTCallBack.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "GJLBTCallBack.h"

@implementation GJLBTCallBack

+ (instancetype)sharedInstance{
    static GJLBTCallBack *call = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        call = [[GJLBTCallBack alloc] init];
    });
    return call;
}

-(instancetype)init{
    self = [super init];
    if (self){
        //nothing need to do ...
    }
    return self;
}

@end
