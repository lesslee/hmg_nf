//
//  CommonResult.h
//  hmg
//
//  Created by Lee on 15/5/6.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonResult : NSObject


@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *OUT_RESULT_NM;
@property(nonatomic,strong)NSString *ID;


-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
