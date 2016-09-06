//
//  ProductViewCell.h
//  hmg
//
//  Created by Hongxianyu on 16/4/13.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ProductName;
//@property (weak, nonatomic) IBOutlet UILabel *spec;
//@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UISwitch *SwPct;
- (IBAction)SwPuct:(UISwitch *)sender;

@end
