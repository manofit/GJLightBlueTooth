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

@property(nonatomic,retain)GJLightBlueTooth *BLE;
@property(nonatomic,strong)CBCharacteristic *writeCharacter;

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
