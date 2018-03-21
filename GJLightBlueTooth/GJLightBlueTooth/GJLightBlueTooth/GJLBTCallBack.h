//
//  GJLBTCallBack.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJLBTBlockDefine.h"

@interface GJLBTCallBack : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic,copy)LBTBlockWhenDiscoverPeriperals BlockWhenDiscoverPeriperals;
@property(nonatomic,copy)LBTBlockWhenSccuessConnectToPeriperal BlockWhenSccuessConnectToPeriperal;
@property(nonatomic,copy)LBTBlockWhenFailConnectToPeriperal BlockWhenFailConnectToPeriperal;
@property(nonatomic,copy)LBTBlockWhenCancelConnectToPeriperal BlockWhenCancelConnectToPeriperal;
@property(nonatomic,copy)LBTBlockWhenDiscoverSevices BlockWhenDiscoverSevices;
@property(nonatomic,copy)LBTBlockWhenDiscoverCharacteritics BlockWhenDiscoverCharacteritics;
@property(nonatomic,copy)LBTBlockWhenDidUpdateValueForCharacteritics BlockWhenDidUpdateValueForCharacteritics;

@end
