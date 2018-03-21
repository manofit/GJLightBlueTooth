//
//  GJLightBlueTooth.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "GJLightBlueTooth.h"

@implementation GJLightBlueTooth
{
    GJLBTCentralManager *_LBTCentralManager;
}

+ (instancetype)sharedLightBlueTooth{
    static GJLightBlueTooth *LBT = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LBT = [[GJLightBlueTooth alloc] init];
    });
    return LBT;
}

-(instancetype)init{
    self = [super init];
    if (self){
        _LBTCentralManager = [[GJLBTCentralManager alloc] init];
    }
    return self;
}

/*
 * 扫描
 * get from user's scan order
 */
- (void)scan{
    [_LBTCentralManager scanPeriperals];
}

/*
 * 停止扫描
 * get from user's stop scan order
 */
- (void)stopScan{
    [_LBTCentralManager stopScanPeriperals];
}

/*
 * 与设备连接
 * get from user's connect order
 */
- (void)connectWithPeripheral:(CBPeripheral *)peripheral{
    [_LBTCentralManager connectToPeripheral:peripheral];
}

/*
 * 与设备断开连接
 * get from user's cancel connect order
 */
- (void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral{
    [_LBTCentralManager cancelConnectWithPeripheral:peripheral];
}

/*
 * 向设备发送指令数据
 * send data
 */
- (void)sendDataToPeriperal:(CBPeripheral *)peripheral Command:(NSString *)command{
    [_LBTCentralManager sendDataToPeripheral:peripheral AndCharacteristics:self.writeCharacteristic Command:command];
}

//=======================================================set block======================================

/*
 * 设置扫描到设备时Block
 * set block when discover peripherals
 */
- (void)setBlockWhenDiscoverPeriperals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [GJLBTCallBack sharedInstance].BlockWhenDiscoverPeriperals = block;
}

/*
 * 设置连接成功时Block
 * set block when connect peripheral successfully
 */
- (void)setBlockWhenSccuessConnectToPeriperal:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    [GJLBTCallBack sharedInstance].BlockWhenSccuessConnectToPeriperal = block;
}

/*
 * 设置连接失败时Block
 * set block when fail to connect periperal
 */
- (void)setBlockWhenFailConnectToPeriperal:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [GJLBTCallBack sharedInstance].BlockWhenFailConnectToPeriperal = block;
}

/*
 * 设置断开连接时Block
 * set block when cancel connect peripheral
 */
- (void)setBlockWhenCancelConnectToPeriperal:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [GJLBTCallBack sharedInstance].BlockWhenCancelConnectToPeriperal = block;
}

/*
 * 设置获取到服务时Block
 * set block when discover services
 */
- (void)setBlockWhenDiscoverServices:(LBTBlockWhenDiscoverSevices)block{
    [GJLBTCallBack sharedInstance].BlockWhenDiscoverSevices = block;
}

/*
 * 设置获取到特征时Block
 * set block when discover characteristics
 */
- (void)setBlockWhenDiscoverCharacteristics:(LBTBlockWhenDiscoverCharacteritics)block{
    [GJLBTCallBack sharedInstance].BlockWhenDiscoverCharacteritics = block;
}

/*
 * 设置当特征值被修改时Block
 * set block when character's value changed
 */
- (void)setBlockWhenDidUpdateValueForCharacteritics:(LBTBlockWhenDidUpdateValueForCharacteritics)block{
    [GJLBTCallBack sharedInstance].BlockWhenDidUpdateValueForCharacteritics = block;
}


@end
