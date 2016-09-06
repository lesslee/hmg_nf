//
//  RankHeaderView.m
//  hmg
//
//  Created by Lee on 15/6/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "RankHeaderView.h"

@implementation RankHeaderView


//Only override drawRect: if you perform custom drawing.
//An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backgroundColor=[UIColor whiteColor];
    
    self.area.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.area.layer.borderWidth=0.5;
    
    self.flow.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.flow.layer.borderWidth=0.5;
    
    self.zhanbi.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.zhanbi.layer.borderWidth=0.5;
    
    self.rank.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.rank.layer.borderWidth=0.5;
    
    self.storeCount.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.storeCount.layer.borderWidth=0.5;
}


@end
