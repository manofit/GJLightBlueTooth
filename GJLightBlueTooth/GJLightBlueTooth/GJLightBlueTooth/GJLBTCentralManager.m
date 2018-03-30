//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth

//
//  GJLBTCentralManager.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "GJLBTCentralManager.h"

#define SleepTimeGap 0.05
@interface GJLBTCentralManager()
@property(nonatomic,retain)CBCentralManager *centralManager;
@property (nonatomic,strong)NSOperationQueue *writeQueue;// send queue 指令队列

@end

@implementation GJLBTCentralManager

- (instancetype)init{
    self = [super init];
    if (self){
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
        
        self.reConnectDeviceArray = [NSMutableArray array];
        
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
- (void)sendDataToPeripheral:(CBPeripheral *)peripheral AndCharacteristics:(CBCharacteristic *)writeCharacteristics Command:(NSString *)command NSEncoding:(NSStringEncoding)encoding{
    
    NSData *cmdData = [[NSString stringWithFormat:@"%@",command] dataUsingEncoding:encoding];
    
    NSOperation *opration = [NSBlockOperation blockOperationWithBlock:^{
        [peripheral writeValue:cmdData
            forCharacteristic:writeCharacteristics
                         type:CBCharacteristicWriteWithoutResponse];
        /*
         * you can set thread time interval.but the order while delay when there are a lot of orders.
         */
        //[NSThread sleepForTimeInterval:SleepTimeGap];
    }];
    
    [self.writeQueue addOperation:opration];
}

/*
 * 读取信号量
 * read RSSI
 */
- (void)readRSSIWithPeriperal:(CBPeripheral *)peripheral{
    [peripheral readRSSI];
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
    
    if (self.BlockWhenCentralManagerUpdateStatus != nil){
        self.BlockWhenCentralManagerUpdateStatus(central);
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (self.BlockWhenDiscoverPeriperals != nil){
        self.BlockWhenDiscoverPeriperals(central,peripheral,advertisementData,RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if (self.BlockWhenSccuessConnectToPeriperal != nil){
        self.BlockWhenSccuessConnectToPeriperal(central,peripheral);
    }
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if (self.BlockWhenFailConnectToPeriperal != nil){
        self.BlockWhenFailConnectToPeriperal(central,peripheral,error);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    if (self.BlockWhenCancelConnectToPeriperal != nil){
        self.BlockWhenCancelConnectToPeriperal(central,peripheral,error);
    }
    
    if ([self.reConnectDeviceArray containsObject:peripheral]){
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

#pragma mark - CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    if (self.BlockWhenRSSIUpdate != nil){
        self.BlockWhenRSSIUpdate(peripheral, RSSI, error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (self.BlockWhenDiscoverSevices != nil){
        self.BlockWhenDiscoverSevices(peripheral, error);
    }
    
    for (CBService *service in peripheral.services){
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (self.BlockWhenDiscoverCharacteritics != nil){
        self.BlockWhenDiscoverCharacteritics(peripheral, service, error);
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (self.BlockWhenDidUpdateValueForCharacteritics != nil){
        self.BlockWhenDidUpdateValueForCharacteritics(peripheral, characteristic, error);
    }
}

@end
