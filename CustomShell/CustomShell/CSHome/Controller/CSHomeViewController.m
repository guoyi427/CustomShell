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
#import "CSDownloadManager.h"
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
    NSString *apiString = [NSString stringWithFormat:@"%@guoyi.php", HostURLString];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:apiString]];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (!data) {
                                   NSLog(@"Error: result Data Null");
                                   return;
                               }
                               NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               NSLog(@"result = %@", result);
                               if ([result[@"code"] integerValue] == 200) {
                                   // success
                                   NSArray *message = result[@"message"];
                                   for (NSDictionary *modelDic in message) {
                                       CSHomeModel *model = [CSHomeModel modelWithDic:modelDic];
                                       [_modelList addObject:model];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [_collectionView reloadData];
                                   });
                               }
                           }];
    
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
