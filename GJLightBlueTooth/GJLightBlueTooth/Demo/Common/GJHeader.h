//
//  GJHeader.h
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#ifndef GJHeader_h
#define GJHeader_h

#import "GJUtil.h"
#import "SVProgressHUD.h"
#import "MyBLETool.h"
#import "CBPeripheral+RSSI.h"

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height

#define weakify(var) __weak typeof(var) AHKWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

#define CharacteristicUUIDNotify @""
#define CharacteristicUUIDWrite @""

#endif /* GJHeader_h */
