//  您好，谢谢您参考我的项目，如果有问题请移步
//  https://github.com/manofit/GJLightBlueTooth
//
//  DataSendViewController.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "DataSendViewController.h"

@interface DataSendViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UILabel *_dataLabel;
    UILabel *_rssiLabel;
}
@property(nonatomic,assign)BOOL isHandleCancel;// 是否是主动断开连接，如果是则不自动重连，否则自动重连 will reconnect if you cancel connect yourself.
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation DataSendViewController
-(NSTimer *)timer{
    if (!_timer){
        _timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(sendHeartBeat) userInfo:nil repeats:YES];
        
        // 将定时器加入循环。mode为NSRunLoopCommonModes，防止页面滑动造成定时器停止。
        // set mode NSRunLoopCommonModes, or timer will stop when page scroll.
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isHandleCancel = NO;
    
    [self addObserver];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"SEND DATA";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    [[MyBLETool sharedMyBLETool] readRSSIWithPeripheral:self.peri];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelConnectToPeriperal:) name:@"CancelConnectToPeriperal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateValueForCharacteritics:) name:@"DidUpdateValueForCharacteritics" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateRSSI:) name:@"DidUpdateRSSI" object:nil];
}

- (void)createUI{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 200, 150, 30)];
    _textField.placeholder = @"command";
    _textField.borderStyle = UITextBorderStyleLine;
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_textField];
    
    UIButton *sendBtn = [GJUtil createBtnWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(_textField.frame) + 20, 100, 30) Title:@"SEND" Font:17.0f TitleColor:[UIColor blackColor] BtnBackgroundColor:[UIColor blueColor] Target:self Action:@selector(sendBtnAction)];
    [self.view addSubview:sendBtn];
    
    _dataLabel = [GJUtil createLabelWithFrame:CGRectMake(30, CGRectGetMaxY(sendBtn.frame) + 20, SCREEN_WIDTH-60, 30) Title:@"return data:" Font:15.0f BackgroundColor:[UIColor yellowColor] TitleColor:[UIColor blackColor]];
    _dataLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dataLabel];
    
    _rssiLabel = [GJUtil createLabelWithFrame:CGRectMake(30, CGRectGetMaxY(_dataLabel.frame) + 20, SCREEN_WIDTH-60, 30) Title:@"rssi:" Font:15.0f BackgroundColor:[UIColor yellowColor] TitleColor:[UIColor blackColor]];
    _rssiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_rssiLabel];
    
    UIButton *heartbeatBtn = [GJUtil createBtnWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(_rssiLabel.frame) + 20, 100, 30) Title:@"Heartbeat" Font:17.0f TitleColor:[UIColor blackColor] BtnBackgroundColor:[UIColor blueColor] Target:self Action:@selector(heartbeatBtnAction)];
    [self.view addSubview:heartbeatBtn];
    
    UIButton *cancelConnectBtn =[GJUtil createBtnWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, CGRectGetMaxY(heartbeatBtn.frame) + 20, 150, 30) Title:@"cancel connect" Font:17.0f TitleColor:[UIColor blackColor] BtnBackgroundColor:[UIColor blueColor] Target:self Action:@selector(cancelConnectBtnAction)];
    [self.view addSubview:cancelConnectBtn];
    
}

- (void)sendBtnAction{
    if (_textField.text.length == 0){
        return;
    }
    
    [[MyBLETool sharedMyBLETool] sendCommandToPeripheral:self.peri Command:_textField.text NSEncoding:NSASCIIStringEncoding];
    
}

- (void)heartbeatBtnAction{
    [self.timer fire];
}

- (void)sendHeartBeat{
    [[MyBLETool sharedMyBLETool] sendCommandToPeripheral:self.peri Command:@"heartbeat_command" NSEncoding:NSASCIIStringEncoding];
}

- (void)cancelConnectBtnAction{
    
    self.isHandleCancel = YES;
    [[MyBLETool sharedMyBLETool] deleteReconnectPeripheral:self.peri];
    
    [[MyBLETool sharedMyBLETool] cancelConnectTo:self.peri];
}

- (void)cancelConnectToPeriperal:(NSNotification *)noti{
    
    if (!self.isHandleCancel){
        return;
    }
    
    [SVProgressHUD showErrorWithStatus:@"disconnect"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didUpdateValueForCharacteritics:(NSNotification *)noti{
    CBCharacteristic *character = (CBCharacteristic *)noti.object;
    if ([character.UUID.UUIDString isEqualToString:CharacteristicUUIDNotify]) {
        if (character.value != nil) {
            _dataLabel.text = [NSString stringWithFormat:@"return data:%@",character.value];
        }
    }
}

- (void)didUpdateRSSI:(NSNotification *)noti{
    _rssiLabel.text = [NSString stringWithFormat:@"rssi:%@",[(NSNumber *)noti.object stringValue]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
