//
//  NotifyModel.h
//  hmg
//
//  Created by Lee on 15/6/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyModel : NSObject

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *SEQ;
@property(nonatomic,strong)NSString *SUBJECT;
@property(nonatomic,strong)NSString *WRITE_DATE;
@property(nonatomic,strong)NSString *BOARD_ID;
@property(nonatomic,strong)NSString *TOTAL_RECORDS;



-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
