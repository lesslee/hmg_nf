//
//  STORE_INFO_SUMMARY.m
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "STORE_INFO_SUMMARY.h"
#import "GDataXMLNode.h"

@implementation STORE_INFO_SUMMARY
@synthesize AREA_NM=_AREA_NM;
@synthesize DEPT_NM=_DEPT_NM;
@synthesize EMP_NM=_EMP_NM;
@synthesize STORE_MANAGER=_STORE_MANAGER;
@synthesize STORE_COUNT=_STORE_COUNT;

@synthesize HZZ=_HZZ;
@synthesize TZHZ=_TZHZ;

@synthesize DYXZ=_DYXZ;

@synthesize LS=_LS;
@synthesize SC=_SC;
@synthesize BH=_BH;
@synthesize DD=_DD;
@synthesize QTQD=_QTQD;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    if (error) {
        return array;
    }
    
    
    NSString *searchStr=[NSString stringWithFormat:@"//%@",name];
    GDataXMLElement *rootNode =[document rootElement];
    
    NSArray *childs = [rootNode nodesForXPath:searchStr error:nil];
    for (GDataXMLNode *item in childs) {
        
        [array addObjectsFromArray:[self childsNodeToDictionary:item ]];
    }
    return  array;
    
}

-(NSMutableArray *)childsNodeToDictionary:(GDataXMLNode *)node
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *childs =[node children];
    for(GDataXMLNode *item in childs){
        STORE_INFO_SUMMARY *model=[[STORE_INFO_SUMMARY alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"AREA_NM" isEqualToString:[item name]]) {
                    [model setAREA_NM:[item stringValue]];
                }
                if ([@"DEPT_NM" isEqualToString:[item name]]) {
                    [model setDEPT_NM:[item stringValue]];
                }
                if ([@"EMP_NM" isEqualToString:[item name]]) {
                    [model setEMP_NM:[item stringValue]];
                }
                if ([@"STORE_MANAGER" isEqualToString:[item name]]) {
                    [model setSTORE_MANAGER:[item stringValue]];
                }
                if ([@"STORE_COUNT" isEqualToString:[item name]]) {
                    [model setSTORE_COUNT:[item stringValue]];
                }
                if ([@"HZZ" isEqualToString:[item name]]) {
                    [model setHZZ:[item stringValue]];
                }
                if ([@"TZHZ" isEqualToString:[item name]]) {
                    [model setTZHZ:[item stringValue]];
                }
                if ([@"DYXZ" isEqualToString:[item name]]) {
                    [model setDYXZ:[item stringValue]];
                }
                if ([@"LS" isEqualToString:[item name]]) {
                    [model setLS:[item stringValue]];
                }
                if ([@"SC" isEqualToString:[item name]]) {
                    [model setSC:[item stringValue]];
                }
                if ([@"BH" isEqualToString:[item name]]) {
                    [model setBH:[item stringValue]];
                }
                if ([@"DD" isEqualToString:[item name]]) {
                    [model setDD:[item stringValue]];
                }
                if ([@"QTQD" isEqualToString:[item name]]) {
                    [model setQTQD:[item stringValue]];
                }
            }
            
            [array addObject:model];
            
        }
        
        
    }
    return array;
}



@end
