//
//  GJLightBlueTooth.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GJLBTCentralManager.h"
#import "GJLBTCallBack.h"
#import "GJLBTBlockDefine.h"

/*
 * 此类作为用户与蓝牙库的中介，用于发指令与回传结果。
 * this class is a agency between user and BLE library, it can send orders and get callback from BLE.
 */
@interface GJLightBlueTooth : NSObject

@property(nonatomic,retain)CBPeripheral *selectedPeri;
@property(nonatomic,retain)CBCharacteristic *writeCharacteristic;
@property(nonatomic,retain)CBCharacteristic *notifyCharacteristic;

/*
 * 创建 LBT 蓝牙单例
 * create BLE single instance
 */
+ (instancetype)sharedLightBlueTooth;

/*
 * 扫描
 * get from user's scan order
 */
- (void)scan;

/*
 * 停止扫描
 * get from user's stop scan order
 */
- (void)stopScan;

/*
 * 与设备连接
 * get from user's connect order
 */
- (void)connectWithPeripheral:(CBPeripheral *)peripheral;

/*
 * 与设备断开连接
 * get from user's cancel connect order
 */
- (void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral;

/*
 * 向设备发送指令数据
 * send data
 */
- (void)sendDataToPeriperal:(CBPeripheral *)peripheral Command:(NSString *)command;

//=======================================================set block======================================

/*
 * 设置扫描到设备时Block
 * set block when discover peripherals
 */
- (void)setBlockWhenDiscoverPeriperals:(LBTBlockWhenDiscoverPeriperals)block;

/*
 * 设置连接成功时Block
 * set block when connect peripheral successfully
 */
- (void)setBlockWhenSccuessConnectToPeriperal:(LBTBlockWhenSccuessConnectToPeriperal)block;

/*
 * 设置连接失败时Block
 * set block when fail to connect periperal
 */
- (void)setBlockWhenFailConnectToPeriperal:(LBTBlockWhenFailConnectToPeriperal)block;

/*
 * 设置断开连接时Block
 * set block when cancel connect peripheral
 */
- (void)setBlockWhenCancelConnectToPeriperal:(LBTBlockWhenCancelConnectToPeriperal)block;

/*
 * 设置获取到服务时Block
 * set block when discover services
 */
- (void)setBlockWhenDiscoverServices:(LBTBlockWhenDiscoverSevices)block;

/*
 * 设置获取到特征时Block
 * set block when discover characteristics
 */
- (void)setBlockWhenDiscoverCharacteristics:(LBTBlockWhenDiscoverCharacteritics)block;

/*
 * 设置当特征值被修改时Block
 * set block when character's value changed
 */
- (void)setBlockWhenDidUpdateValueForCharacteritics:(LBTBlockWhenDidUpdateValueForCharacteritics)block;

@end
