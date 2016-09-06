//
//  ReportUser.h
//  hmg
//
//  Created by Hongxianyu on 16/2/29.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportUser : NSObject

@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *CUSTOM_ID;
@property(nonatomic,strong)NSString *CUSTOM_NM;
@property(nonatomic,strong)NSString *CUSTOM_TYPE;
@property(nonatomic,strong)NSString *CNT;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
