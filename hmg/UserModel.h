//
//  UserModel.h
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, retain) NSString * PERNR;
@property (nonatomic, retain) NSString * ENAME;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
