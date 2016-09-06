//
//  Board_attchment.h
//  hmg
//
//  Created by Hongxianyu on 16/2/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Board_attchment : NSObject

@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *OUT_RESULT_NM;
@property(nonatomic,strong)NSString *FILENAME;
@property(nonatomic,strong)NSString *DOWNLOAD_URL;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
