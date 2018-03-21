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
@property(nonatomic,retain)GJLightBlueTooth *LBT;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"DEVICES";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.LBT = [GJLightBlueTooth sharedLightBlueTooth];
    
    _scanBtn = [GJUtil createBtnWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 250, 100, 40) Title:@"S C A N" Font:17.0f TitleColor:[UIColor blackColor] BtnBackgroundColor:[UIColor blueColor] Target:self Action:@selector(startScan)];
    [self.view addSubview:_scanBtn];
}

-(void)createTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    /*
     * you must performant this!!!
     */
    [self setCentralManagerBlock];
}

-(void)startScan{
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    DevicesListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DevicesListCell" owner:nil options:nil] firstObject];
    }
    if (_dataArray.count > 0){
        CBPeripheral *peripheral = self.dataArray[indexPath.row];
        [cell configCellWithModel:peripheral];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CBPeripheral *peripheral = self.dataArray[indexPath.row];
    
    /*
     * connect
     */
    [self.LBT connectWithPeripheral:peripheral];
}

-(void)setCentralManagerBlock{
    
    /*
     * weak-strong-dance to avoid cycle retain
     */
    weakify(self);
    
    [self.LBT setBlockWhenDiscoverPeriperals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        strongify(self);
        if (![self.dataArray containsObject:peripheral]){
            
            /*
             * If you can define device's name by yourself, you can get it's name by "kCBAdvDataLocalName" key.
             * [peripheral setValue:[advertisementData objectForKey:@"kCBAdvDataLocalName"] forKey:@"deviceName"];
             */
            
            [self.dataArray addObject:peripheral];
            [self.tableView reloadData];
        }
    }];
    
    [self.LBT setBlockWhenSccuessConnectToPeriperal:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showWithStatus:@"disvover services"];
    }];
    
    [self.LBT setBlockWhenFailConnectToPeriperal:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"connect failed"];
    }];
    
    [self.LBT setBlockWhenCancelConnectToPeriperal:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"cancel connect"];
    }];
    
    [self.LBT setBlockWhenDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        [SVProgressHUD showWithStatus:@"disvover characteristics"];
    }];
    
    [self.LBT setBlockWhenDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        strongify(self);
        [SVProgressHUD showSuccessWithStatus:@"connect success"];
        
        for (CBCharacteristic *cha in service.characteristics){
            if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDWrite]){
                self.LBT.writeCharacteristic = cha;
            }
            if ([cha.UUID.UUIDString isEqualToString:CharacteristicUUIDNotify]){
                self.LBT.notifyCharacteristic = cha;
            }
        }
        
        DataSendViewController *vc = [[DataSendViewController alloc] init];
        vc.peri = peripheral;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}

@end
