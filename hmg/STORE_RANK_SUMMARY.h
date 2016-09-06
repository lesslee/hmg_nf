//
//  STORE_RANK_SUMMARY.h
//  hmg
//
//  Created by Lee on 15/6/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STORE_RANK_SUMMARY : NSObject

//城市
@property(nonatomic,strong)NSString *CITY;
//经济排名
@property(nonatomic,strong)NSString *ECONOMIC_RANK;
//门店数量
@property(nonatomic,strong)NSString *STORE_COUNT;
//流向金额
@property(nonatomic,strong)NSString *CITY_FLOW;
//占比
@property(nonatomic,strong)NSString *ZHANBI;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
