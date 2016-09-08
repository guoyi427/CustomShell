//
//  CSHomeViewController.m
//  CustomShell
//
//  Created by guoyi on 16/6/17.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSHomeViewController.h"

//  Controller
#import "CSShellViewController.h"

//  View
#import "CSHomeCollectionViewCell.h"

//  Model
#import "CSHomeModel.h"

@interface CSHomeViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    
    //  Data
    NSMutableArray *_modelList;
}
@end

@implementation CSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareUI];
    [self _prepareData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {
    _modelList = [[NSMutableArray alloc] initWithCapacity:30];
    NSArray *nameList = @[@"myStl", @"DLAM"];
}

- (void)_prepareUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float itemSize = CGRectGetWidth(self.view.bounds)/3.0;
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CSHomeCollectionViewCell class] forCellWithReuseIdentifier:@"stlCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - CollectionView - Delegate & Datasources

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stlCell" forIndexPath:indexPath];
    
    if (indexPath.row > _modelList.count) {
        CSHomeModel *model = _modelList[indexPath.row];
        [cell updateModel:model];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _modelList.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CSShellViewController *shellVC = [[CSShellViewController alloc] init];
    shellVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shellVC animated:YES];
}

@end
