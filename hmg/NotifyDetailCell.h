//
//  NotifyDetailCell.h
//  hmg
//
//  Created by Hongxianyu on 16/5/27.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notifyName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *fileName;
- (IBAction)FileName:(id)sender;

@end
