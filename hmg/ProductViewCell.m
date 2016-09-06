//
//  ProductViewCell.m
//  hmg
//
//  Created by Hongxianyu on 16/4/13.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ProductViewCell.h"

@implementation ProductViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)SwPuct:(UISwitch *)sender {
    
    NSLog(@"开关");
}
@end
