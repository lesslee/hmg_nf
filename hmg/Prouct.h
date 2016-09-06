//
//  Prouct.h
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prouct : NSObject

@property (nonatomic, retain) NSString * OUT_RESULT;
@property (nonatomic, retain) NSString * PROD_ID;
@property (nonatomic, retain) NSString * PROD_NM;
@property (nonatomic, retain) NSString * TYPE_NM;
@property (nonatomic, retain) NSString * RMSPRICE;
@property (nonatomic, retain) NSString * SPEC;

/** 用来保存输入框输入的数据 */
@property (nonatomic,strong) NSString *count1;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
