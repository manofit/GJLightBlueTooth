# GJLightBlueTooth
```GJLightBlueTooth```是一个轻量级蓝牙库。

```GJLightBlueTooth```is a lightweight bluetooth library.

## demo
你可以在[Demo](https://github.com/manofit/GJLightBlueTooth/tree/master/GJLightBlueTooth/GJLightBlueTooth/Demo)中查看如何使用```GJLightBlueTooth```。

You can try to use ```GJLightBlueTooth``` in [Demo](https://github.com/manofit/GJLightBlueTooth/tree/master/GJLightBlueTooth/GJLightBlueTooth/Demo).

## project architecture
整个蓝牙库的架构是：用户 ——> GJLightBlueTooth ——> CoreBlueTooth ——> GJLightBlueTooth ——> 用户。

The architecture of project is: user ——> GJLightBlueTooth ——> CoreBlueTooth ——> GJLightBlueTooth ——> user.

其中：
- GJLightBlueTooth：相当于一个中介，架起来自页面用户的指令和系统CoreBlueTooth交互的桥梁，这里的交互包括向蓝牙设备发送指令和设置回调。
- GJLBTCentralManager：所有与系统CoreBlueTooth的沟通都在这里进行，这里将指令发出去，也在这里获取回调，通过block回传。

There:
- GJLightBlueTooth：is agency between user and system CoreBlueTooth, you can send data and set callback here.
- GJLBTCentralManager: all the communication with system CoreBlueTooth is here, send data and get callback.

而在Demo中，你还会看到MyBLETool这个类，这是为了将Demo项目中页面与业务分离而单独出来的一个类，可以理解为设备类。为了我们不需要在具体的页面中去设置回传的block。

In Demo, you can see the class MyBLETool, this aim to seperate page and service, you can call it Device-Class. So we needn't to set callback block in ViewControllers.

## how to use
在创建页面后，你应该初始化```GJLightBlueTooth```蓝牙工具：```self.BLE = [[GJLightBlueTooth alloc] init]```。

You should init GJLightBlueTooth after create ViewController, ```self.BLE = [[GJLightBlueTooth alloc] init]```.

在获取到Characteristic后，你应该根据实际读写的Characteristic匹配出设备上的CBCharacteristic，保存在本地，用于后面的写与读。

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

这里针对现在很多公司提出需要手机与设备有心跳的要求，开启了一个线程队列。该队列设置能够同时存在的指令数为3。

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
你也可以设置指令间隔时间，但是这样会造成因心跳刷新过快造成的延迟发送。

You can also set time interval between orders, but the orders will delay if you update heartbeat quickly.

## warning
1. 在新版本的iOS中，已经不允许通过```peripheral.RSSI```来获取设备的信号量，必须在用```[peripheral readRSSI]```后，使用回调来获取。这就会造成在扫描到设备时候无法显示信号量。所以专门创建了一个分类CBPeripheral+RSSI，利用Runtime来动态给peripheral创建了一个```rssi```属性。

 In newest iOS system, wo can't get RSSI throungh ```peripheral.RSSI```. Instead, you should get callback after using ```[peripheral readRSSI]```, so we can't show RSSI when discover a lot of deivces. So I created a category CBPeripheral+RSSI, then added a property named ```rssi``` by using Runtime. 
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

 In MyBLETool, you need to set callback GJLBTCentralManager working flow. In case of cycle retain, you'd better set weak-strong dance.
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
## effect
![DeviceList](https://github.com/manofit/GJLightBlueTooth/blob/master/GJLightBlueTooth/GJLightBlueTooth/DeviceListVC.PNG)
![DataSend](https://github.com/manofit/GJLightBlueTooth/blob/master/GJLightBlueTooth/GJLightBlueTooth/DataSendVC.PNG)
