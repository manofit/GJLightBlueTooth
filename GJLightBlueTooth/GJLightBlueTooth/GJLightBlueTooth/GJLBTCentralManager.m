//
//  GJLBTCentralManager.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "GJLBTCentralManager.h"

#define SleepTimeGap 0.05
@implementation GJLBTCentralManager

- (instancetype)init{
    self = [super init];
    if (self){
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        
        self.writeQueue = [[NSOperationQueue alloc] init];
        self.writeQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

/*
 * 扫描
 * scan
 */
- (void)scanPeriperals{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

/*
 * 停止扫描
 * stop scan
 */
- (void)stopScanPeriperals{
    [self.centralManager stopScan];
}

/*
 * 连接
 * connect
 */
- (void)connectToPeripheral:(CBPeripheral *)peripheral{
    [self.centralManager connectPeripheral:peripheral options:nil];
}

/*
 * 断开连接
 * cancel connect
 */
- (void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral{
    [self.centralManager cancelPeripheralConnection:peripheral];
}

/*
 * 发送数据
 * send data
 */
- (void)sendDataToPeripheral:(CBPeripheral *)peripheral AndCharacteristics:(CBCharacteristic *)writeCharacteristics Command:(NSString *)command{
    
    NSData *cmdData = [[NSString stringWithFormat:@"%@",command] dataUsingEncoding:NSASCIIStringEncoding];
    
    NSOperation *opration = [NSBlockOperation blockOperationWithBlock:^{
        [peripheral writeValue:cmdData
            forCharacteristic:writeCharacteristics
                         type:CBCharacteristicWriteWithoutResponse];
        
        [NSThread sleepForTimeInterval:SleepTimeGap];
    }];
    
    [self.writeQueue addOperation:opration];
}

#pragma mark - CBCentralManagerDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (@available(iOS 10.0, *)) {
        if (central.state != CBManagerStatePoweredOn) {
            NSLog(@"CBManagerStatePoweredOff");
            return;
        }
    } else {
        if (central.state != CBCentralManagerStatePoweredOn) {
            NSLog(@"CBCentralManagerStatePoweredOff");
            return;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    //NSLog(@"%@",peripheral);
    if ([GJLBTCallBack sharedInstance].BlockWhenDiscoverPeriperals != nil){
        [GJLBTCallBack sharedInstance].BlockWhenDiscoverPeriperals(central,peripheral,advertisementData,RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if ([GJLBTCallBack sharedInstance].BlockWhenSccuessConnectToPeriperal != nil){
        [GJLBTCallBack sharedInstance].BlockWhenSccuessConnectToPeriperal(central,peripheral);
    }
    
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if ([GJLBTCallBack sharedInstance].BlockWhenFailConnectToPeriperal != nil){
        [GJLBTCallBack sharedInstance].BlockWhenFailConnectToPeriperal(central,peripheral,error);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if ([GJLBTCallBack sharedInstance].BlockWhenCancelConnectToPeriperal != nil){
        [GJLBTCallBack sharedInstance].BlockWhenCancelConnectToPeriperal(central,peripheral,error);
    }
}

#pragma mark - CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if ([GJLBTCallBack sharedInstance].BlockWhenDiscoverSevices != nil){
        [GJLBTCallBack sharedInstance].BlockWhenDiscoverSevices(peripheral, error);
    }
    
    for (CBService *service in peripheral.services){
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if ([GJLBTCallBack sharedInstance].BlockWhenDiscoverCharacteritics != nil){
        [GJLBTCallBack sharedInstance].BlockWhenDiscoverCharacteritics(peripheral, service, error);
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([GJLBTCallBack sharedInstance].BlockWhenDidUpdateValueForCharacteritics != nil){
        [GJLBTCallBack sharedInstance].BlockWhenDidUpdateValueForCharacteritics(peripheral, characteristic, error);
    }
}

@end
