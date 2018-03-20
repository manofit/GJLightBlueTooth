//
//  DevicesListModel.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicesListModel : NSObject

@property(nonatomic,strong)NSString *deviceName;
@property(nonatomic,strong)NSString *macAddress;
@property(nonatomic,strong)NSNumber *RSSI;

@end
