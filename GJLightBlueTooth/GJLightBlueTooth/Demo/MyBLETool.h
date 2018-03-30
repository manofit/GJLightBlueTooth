//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth
//
//  MyBLETool.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/22.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJLightBlueTooth.h"

@interface MyBLETool : NSObject

+ (instancetype)sharedMyBLETool;

- (void)scan;
- (void)stopScan;
- (void)connectTo:(CBPeripheral *)peri;
- (void)cancelConnectTo:(CBPeripheral *)peri;
- (void)readRSSIWithPeripheral:(CBPeripheral *)peri;
- (void)sendCommandToPeripheral:(CBPeripheral *)peri Command:(NSString *)command NSEncoding:(NSStringEncoding)encoding;
- (void)deleteReconnectPeripheral:(CBPeripheral *)peri;
- (void)addReconnectPeripheral:(CBPeripheral *)peri;

@end
