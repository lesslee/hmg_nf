//
//  WeekendViewCell.h
//  hmg
//
//  Created by Hongxianyu on 16/4/14.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekendViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *prodName;
@property (weak, nonatomic) IBOutlet UILabel *spec;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *inpUser;
@property (weak, nonatomic) IBOutlet UILabel *promDtm;
@property (weak, nonatomic) IBOutlet UILabel *posMoney;

@end
