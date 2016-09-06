//
//  Notify.m
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Notify.h"
#import "GDataXMLNode.h"
@implementation Notify

@synthesize EMP_NM = _EMP_NM;
@synthesize CODE_NM = _CODE_NM;
@synthesize TITLE = _TITLE;
@synthesize MSG_ID = _MSG_ID;
@synthesize INP_DTM = _INP_DTM;
@synthesize DESCRIPTION = _DESCRIPTION;
@synthesize OUT_RESULT = _OUT_RESULT;

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
        Notify *model1 = [[Notify alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"EMP_NM" isEqualToString:[item name]]) {
                    [model1 setEMP_NM:[item stringValue]];
                }
                if ([@"CODE_NM" isEqualToString: [item name]]) {
                    [model1 setCODE_NM: [item stringValue]];
                }
                if ([@"TITLE" isEqualToString:[item name]]) {
                    [model1 setTITLE:[item stringValue]];
                }
                
                if ([@"MSG_ID" isEqualToString: [item name]]) {
                    [model1 setMSG_ID:[item stringValue]];
                }
                
                if ([@"INP_DTM" isEqualToString:[item name]]) {
                    [model1 setINP_DTM:[item stringValue]];
                }
                if ([@"DESCRIPTION" isEqualToString:[item name]]) {
                    [model1 setDESCRIPTION:[item stringValue]];
                }
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model1 setOUT_RESULT:[item stringValue]];
                }
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model1];
        }
    }
    
    return array;
}


@end

