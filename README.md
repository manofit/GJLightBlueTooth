
# GJLightBlueTooth
```GJLightBlueTooth```是一个轻量级蓝牙库。
## FOR ENGLISH DOC IN [https://github.com/manofit/GJLightBlueTooth/blob/master/ReadMe_EN.md](https://github.com/manofit/GJLightBlueTooth/blob/master/ReadMe_EN.md)
## demo
你可以在[Demo](https://github.com/manofit/GJLightBlueTooth/tree/master/GJLightBlueTooth/GJLightBlueTooth/Demo)中查看如何使用```GJLightBlueTooth```。

## 项目架构
整个蓝牙库的架构是：用户 ——> GJLightBlueTooth ——> CoreBlueTooth ——> GJLightBlueTooth ——> 用户。

其中：
- GJLightBlueTooth：相当于一个中介，架起来自页面用户的指令和系统CoreBlueTooth交互的桥梁，这里的交互包括向蓝牙设备发送指令和设置回调。
- GJLBTCentralManager：所有与系统CoreBlueTooth的沟通都在这里进行，这里将指令发出去，也在这里获取回调，通过block回传。

而在Demo中，你还会看到MyBLETool这个类，这是为了将Demo项目中页面与业务分离而单独出来的一个类，可以理解为设备类。为了我们不需要在具体的页面中去设置回传的block。

## 怎么使用
在创建页面后，你应该初始化```GJLightBlueTooth```蓝牙工具：```self.BLE = [[GJLightBlueTooth alloc] init]```。

在获取到Characteristic后，你应该根据实际读写的Characteristic匹配出设备上的CBCharacteristic，保存在本地，用于后面的写与读。


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
### 扫描
```
[self.BLE scan]
```
### 停止扫描
```
[self.BLE stopScan]
```
### 连接
```
[self.BLE connectWithPeripheral:peri]
```
### 断开连接
```
[self.BLE cancelConnectWithPeripheral:peri]
```
### 读取信号量
```
[self.BLE readRSSIWithPeriperal:peri]
```
### 发送指令
```
[self.BLE sendDataToPeriperal:peri WriteCharacteristic:self.writeCharacter Command:command NSEncoding:encoding]
```
### 添加断开重连 & 取消断开重连
```
[self.BLE addReconnectPeriphearal:peri];
[self.BLE deleteReconnectPeriphearal:peri];
```
这里针对现在很多公司提出需要手机与设备有心跳的要求，开启了一个线程队列。该队列设置能够同时存在的指令数为3。

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
你也可以设置指令间隔时间，但是这样会造成因心跳刷新过快造成的延迟发送。

## 注意
1. 在新版本的iOS中，已经不允许通过```peripheral.RSSI```来获取设备的信号量，必须在用```[peripheral readRSSI]```后，使用回调来获取。这就会造成在扫描到设备时候无法显示信号量。所以专门创建了一个分类CBPeripheral+RSSI，利用Runtime来动态给peripheral创建了一个```rssi```属性。
```
char nameKey;

- (void)setRssi:(NSNumber *)rssi{
    objc_setAssociatedObject(self, &nameKey, rssi, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)rssi{
    return objc_getAssociatedObject(self, &nameKey);
}
```
2. 在MyBLETool中，需要设置GJLBTCentralManager回调流，这里为了防止循环引用，需要进行weak-strong dance。

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
3. 在发送心跳包时候，计时器的mode需要设置为NSRunLoopCommonModes，防止页面滑动造成计时器停止。
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
## 效果图
![DeviceList](https://github.com/manofit/GJLightBlueTooth/blob/master/GJLightBlueTooth/GJLightBlueTooth/DeviceListVC.PNG)
![DataSend](https://github.com/manofit/GJLightBlueTooth/blob/master/GJLightBlueTooth/GJLightBlueTooth/DataSendVC.PNG)
