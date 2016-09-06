//
//  RankFooterView.m
//  hmg
//
//  Created by Lee on 15/6/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "RankFooterView.h"

@implementation RankFooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.flow.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.flow.layer.borderWidth=0.5;
    
    self.storeCount.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.storeCount.layer.borderWidth=0.5;
    
    self.zongbi.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.zongbi.layer.borderWidth=0.5;
}


@end
