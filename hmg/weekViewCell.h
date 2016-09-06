//
//  weekViewCell.h
//  hmg
//
//  Created by Hongxianyu on 16/4/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weekViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekdtm;
@property (weak, nonatomic) IBOutlet UILabel *weekstore;
@property (weak, nonatomic) IBOutlet UILabel *weekproud;
@property (weak, nonatomic) IBOutlet UILabel *weekqty;


@property (nonatomic, copy) void(^cb)(weekViewCell *);


@end
