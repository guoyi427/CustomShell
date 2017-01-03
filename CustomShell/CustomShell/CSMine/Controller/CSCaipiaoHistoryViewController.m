//
//  CSCaipiaoHistoryViewController.m
//  CustomShell
//
//  Created by kokozu on 2017/1/3.
//  Copyright © 2017年 帅毅. All rights reserved.
//

#import "CSCaipiaoHistoryViewController.h"

//  Model
#import "CSCaipiaoRequestManager.h"

@interface CSCaipiaoHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_historyTableView;
    NSMutableArray *_historyList;
}
@end

static NSString *Identifer_Cell = @"historyCell";

@implementation CSCaipiaoHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _prepareData];
    [self _prepareUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {
    _historyList = [[NSMutableArray alloc] initWithCapacity:31];
    [[CSCaipiaoRequestManager shareInstance] getCaipiaoListWithCode:@"bj11x5" Date:@"2017-01-01" SuccessCallback:^(NSArray *response) {
        [_historyList addObjectsFromArray:response];
        [_historyTableView reloadData];
    } faileCallback:^(NSError *error) {
        
    }];
}

- (void)_prepareUI {
    self.view.backgroundColor = [UIColor whiteColor];
    _historyTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _historyTableView.backgroundColor = [UIColor whiteColor];
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    [_historyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifer_Cell];
    [self.view addSubview:_historyTableView];
}

#pragma mark - TableView - Delegate & Datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifer_Cell];
    if (_historyList.count > indexPath.row) {
        cell.textLabel.text = _historyList[indexPath.row][@"opencode"];
    }
    return cell;
}

@end
