
# GJLightBlueTooth
```GJLightBlueTooth```is a lightweight bluetooth library.

## demo
You can try to use ```GJLightBlueTooth``` in [Demo](https://github.com/manofit/GJLightBlueTooth/tree/master/GJLightBlueTooth/GJLightBlueTooth/Demo).

## project architecture
The architecture of project is: user ——> GJLightBlueTooth ——> CoreBlueTooth ——> GJLightBlueTooth ——> user.

There:
- GJLightBlueTooth：is agency between user and system CoreBlueTooth, you can send data and set callback here.
- GJLBTCentralManager: all the communication with system CoreBlueTooth is here, send data and get callback.

In Demo, you can see the class MyBLETool, this aim to seperate page and service, you can call it Device-Class. So we needn't to set callback block in ViewControllers.

## how to use
You should init GJLightBlueTooth after create ViewController, ```self.BLE = [[GJLightBlueTooth alloc] init]```.

After get Characteristic, you'd better mate CBCharacteristic in device with Characteristic you get, then save it in local for writing and reading.
```
[self.BLE setBlockWhenDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        strongify(self);
        for (CBCharacteristic *cha in service.characteristics){
            if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDWrite]){
                self.writeCharacter = cha;
            }
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverCharacteristics" object:service];
    }];
```
### scan
```
[self.BLE scan]
```
### stop scan
```
[self.BLE stopScan]
```
### connect
```
[self.BLE connectWithPeripheral:peri]
```
### cancel connect
```
[self.BLE cancelConnectWithPeripheral:peri]
```
### read RSSI
```
[self.BLE readRSSIWithPeriperal:peri]
```
### send command
```
[self.BLE sendDataToPeriperal:peri WriteCharacteristic:self.writeCharacter Command:command NSEncoding:encoding]
```
### reconnect & cancel reconnect
```
[self.BLE addReconnectPeriphearal:peri];
[self.BLE deleteReconnectPeriphearal:peri];
```
If you like to keep a heartbeat with device, there is a new thread. you can set max concurrent operation count by yourself.

```
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
```
You can also set time interval between orders, but the orders will delay if you update heartbeat quickly.

## warning
1. In newest iOS system, wo can't get RSSI throungh ```peripheral.RSSI```. Instead, you should get callback after using ```[peripheral readRSSI]```, so we can't show RSSI when discover a lot of deivces. So I created a category CBPeripheral+RSSI, then added a property named ```rssi``` by using Runtime. 
```
char nameKey;

- (void)setRssi:(NSNumber *)rssi{
    objc_setAssociatedObject(self, &nameKey, rssi, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)rssi{
    return objc_getAssociatedObject(self, &nameKey);
}
```

2. In MyBLETool, you need to set callback GJLBTCentralManager working flow. In case of cycle retain, you'd better set weak-strong dance.
```
weakify(self);

[self.BLE setBlockWhenDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        strongify(self);
        for (CBCharacteristic *cha in service.characteristics){
            if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDWrite]){
                self.writeCharacter = cha;
            }
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverCharacteristics" object:service];
    }];
```
3. Set NSTimer mode NSRunLoopCommonModes to avoid stop timer when page scrolling。
```
-(NSTimer *)timer{
if (!_timer){
_timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(sendHeartBeat) userInfo:nil repeats:YES];

// 将定时器加入循环。mode为NSRunLoopCommonModes，防止页面滑动造成定时器停止。
// set mode NSRunLoopCommonModes, or timer will stop when page scroll.
[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

return _timer;
}
```
