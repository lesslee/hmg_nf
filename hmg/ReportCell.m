//
//  ReportCell.m
//  hmg
//
//  Created by Lee on 15/4/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ReportCell.h"
#import "ReportModel.h"
#import "QueryReportViewController.h"
@implementation ReportCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)reportUser:(id)sender {
          NSLog(@"touch");
    }
- (IBAction)reportCompany:(id)sender {
    NSLog(@"touch--");
}


@end

