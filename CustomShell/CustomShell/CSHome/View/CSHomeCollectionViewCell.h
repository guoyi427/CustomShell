//
//  CSHomeCollectionViewCell.h
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSHomeModel;
@interface CSHomeCollectionViewCell : UICollectionViewCell

- (void)updateModel:(CSHomeModel *)model;

@end
