//
//  StoreFlowBP.h
//  hmg
//
//  Created by Hongxianyu on 16/3/7.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreFlowBP : NSObject

@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *REPORT_LOGO;
@property(nonatomic,strong)NSString *REPORT_FLOW;
@property(nonatomic,strong)NSString *REPORT_MONTH;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end