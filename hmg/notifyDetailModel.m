//
//  notifyDetailModel.m
//  hmg
//
//  Created by Hongxianyu on 16/2/23.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "notifyDetailModel.h"
#import "GDataXMLNode.h"
@implementation notifyDetailModel

@synthesize BOARD_ID = _BOARD_ID;
@synthesize SEQ = _SEQ;
@synthesize SUBJECT = _SUBJECT;
@synthesize WRITE_DATE = _WRITE_DATE;
@synthesize WRITER_ID = _WRITER_ID;
@synthesize WRITER_NAME = _WRITER_NAME;
@synthesize HIT_NUM = _HIT_NUM;
@synthesize CONTENT = _CONTENT;


-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    GDataXMLDocument *document;
    if ([data isKindOfClass:[NSString class]]) {
        data=[data stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"xmlns=\"%@\"",name] withString:@""];
        document= [[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    } else {
        document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }
    
    if (error) {
        
        return array;
    }
    
    NSString *searchStr=[NSString stringWithFormat:@"//%@",name];
    GDataXMLElement *rootNode =[document rootElement];
    NSArray *childs = [rootNode nodesForXPath:searchStr error:nil];
    for (GDataXMLNode *item in childs) {
        
        [array addObjectsFromArray:[self childsNodeToDictionary:item]];
    }
    
    return array;
    
}

-(NSMutableArray *)childsNodeToDictionary:(GDataXMLNode *)node
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *childs =[node children];
    for(GDataXMLNode *item in childs){
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"BOARD_ID" isEqualToString:[item name]]) {
                    [self setBOARD_ID:[item stringValue]];
                }
                if ([@"SEQ" isEqualToString:[item name]]) {
                    [self setSEQ:[item stringValue]];
                }
                if ([@"SUBJECT" isEqualToString:[item name]]) {
                    [self setSUBJECT:[item stringValue]];
                }
                if ([@"WRITE_DATE" isEqualToString:[item name]]) {
                    [self setWRITE_DATE:[item stringValue]];
                }
                if ([@"WRITER_ID" isEqualToString:[item name]]) {
                    [self setWRITER_ID:[item stringValue]];
                }
                if ([@"WRITER_NAME" isEqualToString:[item name]]) {
                    [self setWRITER_NAME:[item stringValue]];
                }
                if ([@"HIT_NUM" isEqualToString:[item name]]) {
                    [self setHIT_NUM:[item stringValue]];
                }
                if ([@"CONTENT" isEqualToString:[item name]]) {
                    [self setCONTENT:[item stringValue]];
                }
            }
            NSLog(@"%@",item.stringValue);
            [array addObject:self];
            
        }
        
        
    }
    return array;
}
@end
