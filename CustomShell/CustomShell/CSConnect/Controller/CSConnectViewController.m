//
//  CSConnectViewController.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/28.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSConnectViewController.h"

#import "CSBluetoothManager.h"

@interface CSConnectViewController () <UITableViewDelegate, UITableViewDataSource, CSBluetoothManagerDelegate>
{
    CSBluetoothManager *_bluetoothManager;
    UITableView *_peripheralsTableView;
    
    NSArray *_peripheralsCache;
}
@end

@implementation CSConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _bluetoothManager = [[CSBluetoothManager alloc] init];
    _bluetoothManager.delegate = self;
    
    UIButton *connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    connectButton.frame = CGRectMake(10, 50, 80, 40);
    connectButton.backgroundColor = [UIColor yellowColor];
    [connectButton setTitle:@"链接" forState:UIControlStateNormal];
    [connectButton addTarget:self action:@selector(connectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectButton];
    
    _peripheralsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-100) style:UITableViewStylePlain];
    _peripheralsTableView.delegate = self;
    _peripheralsTableView.dataSource = self;
    [_peripheralsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_peripheralsTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button - Action

- (void)connectButtonAction {
    [_bluetoothManager scan];

}

#pragma mark - TableView - Delegate & Datasources

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (_peripheralsCache.count > indexPath.row) {
        CBPeripheral *peripheral = _peripheralsCache[indexPath.row];
        cell.textLabel.text = peripheral.name;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peripheralsCache.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_peripheralsCache.count > indexPath.row) {
        CBPeripheral *peripheral = _peripheralsCache[indexPath.row];
        [_bluetoothManager connectPeripheral:peripheral];
    }
}

#pragma mark - BluetoothManager - Delegate

- (void)bluetoothManager:(CSBluetoothManager *)manager discoverPeripherals:(NSArray *)peripherals {
    _peripheralsCache = peripherals;
    [_peripheralsTableView reloadData];
}

@end
