//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth
//
//  DataSendViewController.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DataSendViewController : UIViewController

@property(nonatomic,retain)CBPeripheral *peri;

@property(nonatomic,assign)BOOL isHandleCancel;// 是否是主动断开连接，如果是则不自动重连，否则自动重连 will reconnect if you cancel connect yourself.

@end
