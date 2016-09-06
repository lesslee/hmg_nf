//
//  weekend.m
//  hmg
//
//  Created by Hongxianyu on 16/4/14.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "weekend.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"

@implementation weekend

@synthesize ID = _ID;
@synthesize STORE_ID = _STORE_ID;
@synthesize STORE_NM = _STORE_NM;
@synthesize PROD_ID = _PROD_ID;
@synthesize PROD_NM = _PROD_NM;
@synthesize SPEC = _SPEC;
@synthesize QTY = _QTY;
@synthesize PROM_DTM = _PROM_DTM;
@synthesize INP_USER = _INP_USER;
@synthesize EMP_NM = _EMP_NM;
@synthesize POS_MONEY = _POS_MONEY;
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
        weekend *model2 = [[weekend alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"ID" isEqualToString:[item name]]) {
                    [model2 setID:[item stringValue]];
                }
                if ([@"STORE_ID" isEqualToString: [item name]]) {
                    [model2 setSTORE_ID: [item stringValue]];
                }
                if ([@"STORE_NM" isEqualToString:[item name]]) {
                    [model2 setSTORE_NM:[item stringValue]];
                }
                
                if ([@"PROD_ID" isEqualToString: [item name]]) {
                    [model2 setPROD_ID:[item stringValue]];
                }
                
                if ([@"PROD_NM" isEqualToString:[item name]]) {
                    [model2 setPROD_NM:[item stringValue]];
                }
                if ([@"SPEC" isEqualToString:[item name]]) {
                    [model2 setSPEC:[item stringValue]];
                }
                if ([@"QTY" isEqualToString:[item name]]) {
                    [model2 setQTY:[item stringValue]];
                }
                if ([@"PROM_DTM" isEqualToString:[item name]]) {
                    [model2 setPROM_DTM:[item stringValue]];
                }
                if ([@"INP_USER" isEqualToString:[item name]]) {
                    [model2 setINP_USER:[item stringValue]];
                }
                if ([@"EMP_NM" isEqualToString:[item name]]) {
                    [model2 setEMP_NM:[item stringValue]];
                }
                if ([@"POS_MONEY" isEqualToString:[item name]]) {
                    [model2 setPOS_MONEY:[item stringValue]];
                }
                if ([@"TOTAL_RECORDS" isEqualToString:[item name]]) {
                    [model2 setTOTAL_RECORDS:[item stringValue]];
                }
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model2];
        }
    }
    
    return array;
}


@end
