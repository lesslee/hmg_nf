//
//  Log.h
//  hmg
//
//  Created by Hongxianyu on 16/5/26.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log : NSObject
@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *OUT_RESULT_NM;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
