//
//  ReportPhoto.h
//  hmg
//
//  Created by Lee on 15/4/15.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportPhoto : NSObject

@property(nonatomic,strong)NSString *FILE_PATH;
@property(nonatomic,strong)NSString *FILE_NM1;
@property(nonatomic,strong)NSString *FILE_NM2;


-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
