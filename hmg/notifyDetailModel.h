//
//  notifyDetailModel.h
//  hmg
//
//  Created by Hongxianyu on 16/2/23.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface notifyDetailModel : NSObject

@property (nonatomic ,strong) NSString *BOARD_ID;
@property (nonatomic ,strong) NSString *SEQ;
@property (nonatomic ,strong) NSString *SUBJECT;
@property (nonatomic ,strong) NSString *WRITE_DATE;
@property (nonatomic ,strong) NSString *WRITER_ID;
@property (nonatomic ,strong) NSString *WRITER_NAME;
@property (nonatomic ,strong) NSString *HIT_NUM;
@property (nonatomic ,strong) NSString *CONTENT;
@property (nonatomic ,strong) NSString *ATTACHMENT;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
