//
//  MainCell.h
//  hmg
//
//  Created by Hongxianyu on 16/5/3.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prouct.h"

@interface MainCell : UITableViewCell

@property (nonatomic,strong) Prouct *model;

@property (weak, nonatomic) IBOutlet UILabel *prouctname;
@property (weak, nonatomic) IBOutlet UITextField *prouctNumber;

+ (instancetype) loadCellViewWithTableView:(UITableView *) tableView;
@end
