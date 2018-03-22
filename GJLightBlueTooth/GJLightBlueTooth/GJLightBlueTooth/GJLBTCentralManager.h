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


/*
 * 此类是真正的蓝牙库，所有从用户端发来的指令经LBT转发后到这里，发送给设备，并从设备获取数据，回传给用户。
 * it's real BLE library, orders from user finally to here by LBT, then send to peripheral, and get data from periperal.
 */
@interface GJLBTCentralManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,copy)LBTBlockWhenCentralManagerUpdateStatus BlockWhenCentralManagerUpdateStatus;
@property(nonatomic,copy)LBTBlockWhenDiscoverPeriperals BlockWhenDiscoverPeriperals;
@property(nonatomic,copy)LBTBlockWhenSccuessConnectToPeriperal BlockWhenSccuessConnectToPeriperal;
@property(nonatomic,copy)LBTBlockWhenFailConnectToPeriperal BlockWhenFailConnectToPeriperal;
@property(nonatomic,copy)LBTBlockWhenCancelConnectToPeriperal BlockWhenCancelConnectToPeriperal;
@property(nonatomic,copy)LBTBlockWhenDiscoverSevices BlockWhenDiscoverSevices;
@property(nonatomic,copy)LBTBlockWhenDiscoverCharacteritics BlockWhenDiscoverCharacteritics;
@property(nonatomic,copy)LBTBlockWhenDidUpdateValueForCharacteritics BlockWhenDidUpdateValueForCharacteritics;
@property(nonatomic,copy)LBTBlockWhenRSSIUpdate BlockWhenRSSIUpdate;

@property(nonatomic,retain)CBCentralManager *centralManager;
@property (nonatomic,strong)NSOperationQueue *writeQueue;// send queue 指令队列

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
- (void)sendDataToPeripheral:(CBPeripheral *)peripheral AndCharacteristics:(CBCharacteristic *)writeCharacteristics Command:(NSString *)command NSEncoding:(NSStringEncoding)encoding;

/*
 * 读取信号量
 * read RSSI
 */
- (void)readRSSIWithPeriperal:(CBPeripheral *)peripheral;

@end
