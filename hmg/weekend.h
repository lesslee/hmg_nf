//
//  weekend.h
//  hmg
//
//  Created by Hongxianyu on 16/4/14.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weekend : NSObject

{
    NSString *_ID;
    NSString *_STORE_ID;
    NSString *_STORE_NM;
    NSString *_PROD_ID;
    NSString *_PROD_NM;
    NSString *_SPEC;
    NSString *_QTY;
    NSString *_PROM_DTM;
    NSString *_INP_USER;
    NSString *_EMP_NM;
    NSString *_POS_MONEY;
    NSString *_TOTAL_RECORDS;
}
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *STORE_ID;
@property(nonatomic,strong)NSString *STORE_NM;
@property(nonatomic,strong)NSString *PROD_ID;
@property(nonatomic,strong)NSString *PROD_NM;
@property(nonatomic,strong)NSString *SPEC;
@property(nonatomic,strong)NSString *QTY;
@property(nonatomic,strong)NSString *PROM_DTM;
@property(nonatomic,strong)NSString *INP_USER;
@property(nonatomic,strong)NSString *EMP_NM;
@property(nonatomic,strong)NSString *TOTAL_RECORDS;
@property(nonatomic,strong)NSString *POS_MONEY;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
