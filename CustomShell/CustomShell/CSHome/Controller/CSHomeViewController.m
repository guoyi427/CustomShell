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
    if (!_modelList) {
        _modelList = [[NSMutableArray alloc] initWithCapacity:30];
    } else {
        [_modelList removeAllObjects];
    }
    
    NSArray *nameList = @[@"DLAM", @"三角恐龙1", @"战斗的鳄鱼1", @"Dota1", @"Garrosh Hellscream1", @"Grommash Hellscream1"];
    NSArray *imageUrlList = @[
                              @"http://img4.imgtn.bdimg.com/it/u=3930485844,815254076&fm=206&gp=0.jpg",
                              @"http://image.3dhoo.com/NewsDescImages/20160428/20160428_084753_748_13411.jpg",
                              @"http://image.3dhoo.com/NewsDescImages/20160428/20160428_184357_889_12927.jpg",
                              @"http://image.3dhoo.com/NewsDescImages/20160427/20160427_065119_858_3696.jpg",
                              @"http://image.3dhoo.com/NewsDescImages/20160613/160613_160623_70346840.gif",
                              @"http://image.3dhoo.com/NewsDescImages/20160613/160613_160647_34766998.gif",
                              ];
    NSString *mainBundelPath = [NSBundle mainBundle].bundlePath;
    for (int i = 0; i < nameList.count; i ++) {
        CSHomeModel *model = [[CSHomeModel alloc] init];
        model.name = nameList[i];
        model.imageURL = imageUrlList[i];
        model.path = [mainBundelPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.stl", model.name]];
        [_modelList addObject:model];
    }
    [_collectionView reloadData];
}

- (void)_prepareUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float itemSize = CGRectGetWidth(self.view.bounds)/3.0 - 1;
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CSHomeCollectionViewCell class] forCellWithReuseIdentifier:@"stlCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - CollectionView - Delegate & Datasources

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stlCell" forIndexPath:indexPath];
    
    if (indexPath.row < _modelList.count) {
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
    shellVC.model = _modelList[indexPath.row];
    [self.navigationController pushViewController:shellVC animated:YES];
}

@end
