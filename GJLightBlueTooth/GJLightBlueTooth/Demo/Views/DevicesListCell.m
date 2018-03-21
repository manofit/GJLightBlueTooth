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
}

@end
