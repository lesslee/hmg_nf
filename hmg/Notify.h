//
//  Notify.h
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notify : NSObject

@property (nonatomic, strong)NSString *EMP_NM;
@property (nonatomic, strong)NSString *CODE_NM;
@property (nonatomic, strong)NSString *MSG_ID;
@property (nonatomic, strong)NSString *TITLE;
@property (nonatomic, strong)NSString *DESCRIPTION;
@property (nonatomic, strong)NSString *INP_DTM;
@property (nonatomic, strong)NSString *OUT_RESULT;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
