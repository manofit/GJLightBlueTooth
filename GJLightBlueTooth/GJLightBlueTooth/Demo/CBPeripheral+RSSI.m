//
//  CBPeripheral+RSSI.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/22.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "CBPeripheral+RSSI.h"

@implementation CBPeripheral (RSSI)

char nameKey;

- (void)setRssi:(NSNumber *)rssi{
    objc_setAssociatedObject(self, &nameKey, rssi, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)rssi{
    return objc_getAssociatedObject(self, &nameKey);
}


@end
