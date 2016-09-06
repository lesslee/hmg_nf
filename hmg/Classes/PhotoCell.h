//
//  PhotoCell.h
//  hmg
//
//  Created by Lee on 15/5/19.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, strong)UIImageView *imageView;
@end
