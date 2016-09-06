//
//  ReportCell.h
//  hmg
//
//  Created by Lee on 15/4/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *company;
@property (weak, nonatomic) IBOutlet UIButton *ename;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *rmk;
@property (strong, nonatomic) IBOutlet UILabel *product;
@property (strong, nonatomic) IBOutlet UILabel *purpose;

@end
