//
//  DevicesListViewController.m
//  GJLightBlueTooth
//
//  Created by 高军 on 2018/3/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

#import "DevicesListViewController.h"
#import "DevicesListCell.h"
#import "DataSendViewController.h"

@interface DevicesListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_scanBtn;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,retain)MyBLETool *LBT;
@end

@implementation DevicesListViewController
/*
 * lazy load
 */
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    self.navigationItem.title = @"DEVICES";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.LBT = [MyBLETool sharedMyBLETool];
    
    _scanBtn = [GJUtil createBtnWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 250, 100, 40) Title:@"S C A N" Font:17.0f TitleColor:[UIColor blackColor] BtnBackgroundColor:[UIColor blueColor] Target:self Action:@selector(startScan)];
    [self.view addSubview:_scanBtn];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centralManagerStatusUpdate:) name:@"CentralManagerStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverPeriperals:) name:@"DiscoverPeriperals" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sccuessConnectToPeriperal:) name:@"SccuessConnectToPeriperal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failConnectToPeriperal:) name:@"FailConnectToPeriperal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelConnectToPeriperal:) name:@"CancelConnectToPeriperal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverServices:) name:@"DiscoverServices" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoverCharacteristics:) name:@"DiscoverCharacteristics" object:nil];
}

- (void)createTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

}

- (void)startScan{
    
    [_scanBtn removeFromSuperview];
    
    if (self.dataArray.count > 0){
        [self.dataArray removeAllObjects];
    }
    
    [self createTableView];
    
    /*
     * start scan devices
     */
    [self.LBT scan];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    DevicesListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DevicesListCell" owner:nil options:nil] firstObject];
    }
    if (self.dataArray.count > 0){
        CBPeripheral *peripheral = self.dataArray[indexPath.row];
        [cell configCellWithModel:peripheral];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral *peripheral = self.dataArray[indexPath.row];
    
    /*
     * connect
     */
    [self.LBT connectTo:peripheral];
}

- (void)centralManagerStatusUpdate:(NSNotification *)noti{
    NSString *centralStatus = (NSString *)noti.object;
    if ([centralStatus isEqualToString:@"NO"]){
        [SVProgressHUD showErrorWithStatus:@"open mobile BLE"];
    }
}

- (void)discoverPeriperals:(NSNotification *)noti{
    CBPeripheral *peri = (CBPeripheral *)noti.object;
    if (![self.dataArray containsObject:peri]){
        [self.dataArray addObject:peri];
        
        [self.tableView reloadData];
    }
}

- (void)sccuessConnectToPeriperal:(NSNotification *)noti{
    [SVProgressHUD showSuccessWithStatus:@"connect success"];
    
    DataSendViewController *vc = [[DataSendViewController alloc] init];
    vc.peri = (CBPeripheral *)noti.object;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)failConnectToPeriperal:(NSNotification *)noti{
    [SVProgressHUD showErrorWithStatus:@"connect failed"];
}

- (void)cancelConnectToPeriperal:(NSNotification *)noti{
    [SVProgressHUD showErrorWithStatus:@"disconnect"];
}

- (void)discoverServices:(NSNotification *)noti{
    //[SVProgressHUD showWithStatus:@"search characteristics"];
}

- (void)discoverCharacteristics:(NSNotification *)noti{
    /*
     * in some case, device connect success only when you can search characteritics, so you can send and get data.
     */
    //[SVProgressHUD showSuccessWithStatus:@"connect success"];
}

@end
