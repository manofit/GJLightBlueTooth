//
//  GJLBTCentralManager.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GJLBTBlockDefine.h"
#import "GJLBTCallBack.h"

/*
 * 此类是真正的蓝牙库，所有从用户端发来的指令经LBT转发后到这里，发送给设备，并从设备获取数据，回传给用户。
 * it's real BLE library, orders from user finally to here by LBT, then send to peripheral, and get data from periperal.
 */
@interface GJLBTCentralManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,retain)CBCentralManager *centralManager;
// send queue 指令队列
@property (nonatomic,strong)NSOperationQueue *writeQueue;

/*
 * 扫描
 * scan
 */
- (void)scanPeriperals;

/*
 * 停止扫描
 * stop scan
 */
- (void)stopScanPeriperals;

/*
 * 连接
 * connect
 */
- (void)connectToPeripheral:(CBPeripheral *)peripheral;

/*
 * 断开连接
 * cancel connect
 */
- (void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral;

/*
 * 发送数据
 * send data
 */
- (void)sendDataToPeripheral:(CBPeripheral *)peripheral AndCharacteristics:(CBCharacteristic *)writeCharacteristics Command:(NSString *)command;

@end
