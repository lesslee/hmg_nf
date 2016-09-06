//
//  Store.h
//  hmg
//
//  Created by Lee on 15/4/29.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject <NSCoding>

@property (nonatomic, retain) NSString * STORE_ID;
@property (nonatomic, retain) NSString * STORE_NM;
@property (nonatomic, retain) NSString * IS_MANAGE;
@property (nonatomic, retain) NSString * ADDR;
@property (nonatomic, retain) NSString * GPS_LON;
@property (nonatomic, retain) NSString * GPS_LAT;
@property (nonatomic, retain) NSString * TOTAL_RECORDS;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
