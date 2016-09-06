//
//  PhotoCell.m
//  hmg
//
//  Created by Lee on 15/5/19.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "PhotoCell.h"
#import "UploadViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCell()

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        self.backgroundColor = [UIColor clearColor];
        [self imageView];
        
    }
    return self;
}


//- (void)setAsset:(JKAssets *)asset{
//    if (_asset != asset) {
//        
//            NSString *localFilePath1 = [NSString stringWithFormat:@"%@/Documents/IMG_1294.jpg",NSHomeDirectory()];
//            NSLog(@"%@--------",localFilePath1);
//        
//            UIImage *savedImage1 = [[UIImage alloc] initWithContentsOfFile:localFilePath1];
//            NSLog(@"%@========",savedImage1);
//            self.imageView.image = savedImage1;
//        }
//}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.layer.cornerRadius = 0.0f;
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
        _imageView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end

