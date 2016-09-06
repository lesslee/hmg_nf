//
//  MonthReport.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "MonthReport.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"
@implementation MonthReport
@synthesize OUT_RESULT = _OUT_RESULT;
@synthesize STORE_ID = _STORE_ID;
@synthesize STORE_NM = _STORE_NM;
@synthesize PRODUCT_ID = _PRODUCT_ID;
@synthesize MONTH = _MONTH;
@synthesize INVENTORY = _INVENTORY;
@synthesize SALES_QTY = _SALES_QTY;
@synthesize UDP_USER = _UDP_USER;
@synthesize EMP_NM = _EMP_NM;
@synthesize UDP_DTM = _UDP_DTM;
@synthesize PRODUCT_NM= _PRODUCT_NM;

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
        MonthReport *model = [[MonthReport alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model setOUT_RESULT:[item stringValue]];
                }
                if ([@"STORE_ID" isEqualToString: [item name]]) {
                    [model setSTORE_ID: [item stringValue]];
                }
                if ([@"STORE_NM" isEqualToString: [item name]]) {
                    [model setSTORE_NM: [item stringValue]];
                }
                if ([@"PRODUCT_ID" isEqualToString: [item name]]) {
                    [model setPRODUCT_ID: [item stringValue]];
                }
                if ([@"MONTH" isEqualToString: [item name]]) {
                    [model setMONTH: [item stringValue]];
                }
                if ([@"INVENTORY" isEqualToString: [item name]]) {
                    [model setINVENTORY: [item stringValue]];
                }
                if ([@"SALES_QTY" isEqualToString: [item name]]) {
                    [model setSALES_QTY: [item stringValue]];
                }
                if ([@"UDP_USER" isEqualToString: [item name]]) {
                    [model setUDP_USER: [item stringValue]];
                }
                if ([@"EMP_NM" isEqualToString: [item name]]) {
                    [model setEMP_NM: [item stringValue]];
                }
                if ([@"UDP_DTM" isEqualToString: [item name]]) {
                    [model setUDP_DTM: [item stringValue]];
                }
                if ([@"PRODUCT_NM" isEqualToString: [item name]]) {
                    [model setPRODUCT_NM: [item stringValue]];
                }
       
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
        }
    }
    
    return array;
}

@end
