//
//  NotifyModel.m
//  hmg
//
//  Created by Lee on 15/6/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "NotifyModel.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"


@implementation NotifyModel
@synthesize SEQ = _SEQ;
@synthesize WRITE_DATE = _WRITE_DATE;
@synthesize SUBJECT = _SUBJECT;
@synthesize BOARD_ID = _BOARD_ID;
@synthesize TOTAL_RECORDS = _TOTAL_RECORDS;


-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    if (error) {
        return array;
    }
    
    
    NSString *searchStr = [NSString stringWithFormat:@"//%@",name];
    GDataXMLElement *rootNode = [document rootElement];
    
    NSArray *childs = [rootNode nodesForXPath:searchStr error:nil];
    for (GDataXMLNode *item in childs){
        [array addObjectsFromArray:[self childsNodeToDictionary:item]];
        
    }
    return array;
    
}

-(NSMutableArray *)childsNodeToDictionary:(GDataXMLNode *)node
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *childs =[node children];
    
    for (GDataXMLNode *item in childs) {
        NotifyModel *model = [[NotifyModel alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"BOARD_ID" isEqualToString:[item name]]) {
                    [model setBOARD_ID:[item stringValue]];
                }
                if ([@"SEQ" isEqualToString: [item name]]) {
                    [model setSEQ: [item stringValue]];
                }
                if ([@"SUBJECT" isEqualToString:[item name]]) {
                    [model setSUBJECT:[item stringValue]];
                }
                
                if ([@"WRITE_DATE" isEqualToString: [item name]]) {
                    [model setWRITE_DATE:[item stringValue]];
                }
                
                if ([@"TOTAL_RECORDS" isEqualToString:[item name]]) {
                    [model setTOTAL_RECORDS:[item stringValue]];
                }
            }
            NSLog(@"%@",item.stringValue);

            [array addObject:model];
        }
    }
    
    return array;
}


@end
