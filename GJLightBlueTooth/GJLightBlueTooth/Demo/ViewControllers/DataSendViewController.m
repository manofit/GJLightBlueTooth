//
//  DataSendViewController.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "DataSendViewController.h"

@interface DataSendViewController ()
{
    UITextField *_textField;
    UILabel *_dataLabel;
}
@end

@implementation DataSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"SEND DATA";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)createUI{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 100, 150, 30)];
    [self.view addSubview:_textField];
    
    UIButton *sendBtn = [GJUtil createBtnWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(_textField.frame) + 20, 100, 30) Title:@"SEND" Font:17.0f TitleColor:[UIColor blackColor] BtnBackgroundColor:[UIColor blueColor] Target:self Action:@selector(sendBtnAction)];
    [self.view addSubview:sendBtn];
    
    _dataLabel = [GJUtil createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(sendBtn.frame) + 20, SCREEN_WIDTH-30, 30) Title:@"" Font:15.0f BackgroundColor:[UIColor yellowColor] TitleColor:[UIColor blackColor]];
    [self.view addSubview:_dataLabel];
}

-(void)sendBtnAction{
    if (_textField.text.length == 0){
        return;
    }
    
    [[GJLightBlueTooth sharedLightBlueTooth] sendDataToPeriperal:self.peri Command:_textField.text];
}


@end
