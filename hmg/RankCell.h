//
//  RankCell.h
//  hmg
//
//  Created by Lee on 15/6/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *flow;
@property (strong, nonatomic) IBOutlet UILabel *rank;
@property (strong, nonatomic) IBOutlet UILabel *storeCount;
@property (strong, nonatomic) IBOutlet UILabel *zhanbi;

@end
