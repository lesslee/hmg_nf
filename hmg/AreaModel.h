//
//  AreaModel.h
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject


@property (nonatomic, retain) NSString * DEPT_ID;
@property (nonatomic, retain) NSString * DEPT_NM;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
