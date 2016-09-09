//
//  CSHomeCollectionViewCell.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/8.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSHomeCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "CSHomeModel.h"

@interface CSHomeCollectionViewCell ()
{
    UIImageView *_imageView;
}

@end

@implementation CSHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

#pragma mark - Public Methods

- (void)updateModel:(CSHomeModel *)model {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"placeholde.jpg"]];
}

@end
