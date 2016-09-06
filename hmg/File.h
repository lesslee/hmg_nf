//
//  File.h
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property (nonatomic, strong)NSString *FILE_SEQ;
@property (nonatomic, strong)NSString *FILE_PATH;
@property (nonatomic, strong)NSString *FILE_NM1;
@property (nonatomic, strong)NSString *FILE_NM2;
@property (nonatomic, strong)NSString *OUT_RESULT;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
