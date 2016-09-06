//
//  MainCell.m
//  hmg
//
//  Created by Hongxianyu on 16/5/3.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "MainCell.h"


@interface MainCell ()<UITextFieldDelegate>
@end

@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.prouctNumber.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype) loadCellViewWithTableView:(UITableView *) tableView
{
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main_cell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Prouct *)model
{
    _model = model;
    if (model.count1 != nil) {
        self.prouctNumber.text = model.count1;
    }else{
        self.prouctNumber.text = nil;
    }
    self.prouctname.text = model.PROD_NM;
}

- (IBAction)valueChanged:(UITextField *)sender {
    
    self.model.count1 = sender.text;
}

@end
