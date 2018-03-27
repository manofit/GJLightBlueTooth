//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth

//
//  GJLBTBlockDefine.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LBTBlockWhenCentralManagerUpdateStatus)(CBCentralManager *central);
typedef void (^LBTBlockWhenDiscoverPeriperals)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);
typedef void (^LBTBlockWhenSccuessConnectToPeriperal)(CBCentralManager *central,CBPeripheral *peripheral);
typedef void (^LBTBlockWhenFailConnectToPeriperal)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
typedef void (^LBTBlockWhenCancelConnectToPeriperal)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
typedef void (^LBTBlockWhenDiscoverSevices)(CBPeripheral *peripheral,NSError *error);
typedef void (^LBTBlockWhenDiscoverCharacteritics)(CBPeripheral *peripheral,CBService *service, NSError *error);
typedef void (^LBTBlockWhenDidUpdateValueForCharacteritics)(CBPeripheral *peripheral,CBCharacteristic *characteritic,NSError *error);
typedef void (^LBTBlockWhenRSSIUpdate)(CBPeripheral *peripheral,NSNumber *RSSI,NSError *error);

@interface GJLBTBlockDefine : NSObject

@end
