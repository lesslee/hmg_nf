//
//  Agent.h
//  hmg
//
//  Created by Lee on 15/3/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Agent : NSObject

@property (nonatomic, retain) NSString * AGENT_ID;
@property (nonatomic, retain) NSString * AGENT_NM;
@property (nonatomic, retain) NSString * ADDR;
@property (nonatomic, retain) NSString *GPS_LON;
@property (nonatomic, retain) NSString *GPS_LAT;
@property (nonatomic, retain) NSString * TOTAL_RECORDS;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;


@end
