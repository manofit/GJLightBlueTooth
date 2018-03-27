//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth
//
//  DevicesListCell.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "DevicesListCell.h"

@implementation DevicesListCell

-(void)configCellWithModel:(CBPeripheral *)peripheral{
    
    self.deviceNameLabel.text = peripheral.name?peripheral.name:@"no name";
    
    /*
     * mac address in iOS can't be get, you can use UUIDString to sign device. but UUIDString in different mobiles are different.
     */
    self.macAddressLabel.text = peripheral.identifier.UUIDString;
    
    self.rssiLabel.text = [peripheral.rssi stringValue];
}

@end
