//
//  CBPeripheral+RSSI.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/22.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <objc/runtime.h>

@interface CBPeripheral (RSSI)

@property(nonatomic,strong)NSNumber *rssi;

@end
