//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth
//
//  MyBLETool.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/22.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "MyBLETool.h"

@implementation MyBLETool


+ (instancetype)sharedMyBLETool{
    static MyBLETool *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[MyBLETool alloc] init];
    });
    return share;
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.BLE = [[GJLightBlueTooth alloc] init];
        
        [self setLightBlueToothWorkingFlow];
    }
    return self;
}

- (void)scan{
    [self.BLE scan];
}

- (void)stopScan{
    [self.BLE stopScan];
}

- (void)connectTo:(CBPeripheral *)peri{
    [self.BLE connectWithPeripheral:peri];
}

- (void)cancelConnectTo:(CBPeripheral *)peri{
    [self.BLE cancelConnectWithPeripheral:peri];
}

- (void)readRSSIWithPeripheral:(CBPeripheral *)peri{
    [self.BLE readRSSIWithPeriperal:peri];
}

- (void)sendCommandToPeripheral:(CBPeripheral *)peri Command:(NSString *)command NSEncoding:(NSStringEncoding)encoding{
    [self.BLE sendDataToPeriperal:peri WriteCharacteristic:self.writeCharacter Command:command NSEncoding:encoding];
}

- (void)addReconnectPeripheral:(CBPeripheral *)peri{
    [self.BLE addReconnectPeriphearal:peri];
}

- (void)deleteReconnectPeripheral:(CBPeripheral *)peri{
    [self.BLE deleteReconnectPeriphearal:peri];
}

- (void)setLightBlueToothWorkingFlow{

    weakify(self);
    
    [self.BLE setBlockWhenCentralManagerStatusUpdate:^(CBCentralManager *central) {
        NSString *isAvaliable = @"NO";
        if (@available(iOS 10.0, *)) {
            switch (central.state) {
                case CBManagerStatePoweredOn:
                    isAvaliable = @"YES";
                    break;
                default:
                    isAvaliable = @"NO";
                    break;
            }
        } else {
            switch (central.state) {
                case CBCentralManagerStatePoweredOn:
                    isAvaliable = @"YES";
                    break;
                default:
                    isAvaliable = @"NO";
                    break;
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CentralManagerStatusUpdate" object:isAvaliable];
    }];
    
    [self.BLE setBlockWhenDiscoverPeriperals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        /*
         * 这里使用runtime动态的给peripheral增加一个属性，解决peripheral不能绑定rssi的问题
         * use Runtime to bind a rssi property to peripheral.
         */
        peripheral.rssi = RSSI;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverPeriperals" object:peripheral];
    }];
    
    [self.BLE setBlockWhenSccuessConnectToPeriperal:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SccuessConnectToPeriperal" object:peripheral];
    }];
    
    [self.BLE setBlockWhenFailConnectToPeriperal:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FailConnectToPeriperal" object:peripheral];
    }];
    
    [self.BLE setBlockWhenCancelConnectToPeriperal:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelConnectToPeriperal" object:peripheral];
    }];
    
    [self.BLE setBlockWhenDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverServices" object:peripheral];
    }];
    
    [self.BLE setBlockWhenDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        strongify(self);
        for (CBCharacteristic *cha in service.characteristics){
            if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDWrite]){
                self.writeCharacter = cha;
            }
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverCharacteristics" object:service];
    }];
    
    [self.BLE setBlockWhenDidUpdateValueForCharacteritics:^(CBPeripheral *peripheral, CBCharacteristic *characteritic, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidUpdateValueForCharacteritics" object:characteritic];
    }];
    
    [self.BLE setBlockWhenDidUpdateRSSI:^(CBPeripheral *peripheral, NSNumber *RSSI, NSError *error) {
        NSLog(@"%@",RSSI);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidUpdateRSSI" object:RSSI];
    }];
    
}

@end
