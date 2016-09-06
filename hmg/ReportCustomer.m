//
//  ReportCustomer.m
//  hmg
//
//  Created by Hongxianyu on 16/3/2.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ReportCustomer.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"
@implementation ReportCustomer
@synthesize OUT_RESULT = _OUT_RESULT;
@synthesize USER_ID = _USER_ID;
@synthesize EMP_NM = _EMP_NM;
@synthesize CNT = _CNT;

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
        ReportCustomer *model = [[ReportCustomer alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model setOUT_RESULT:[item stringValue]];
                }
                if ([@"USER_ID" isEqualToString: [item name]]) {
                    [model setUSER_ID: [item stringValue]];
                }
                if ([@"EMP_NM" isEqualToString: [item name]]) {
                    [model setEMP_NM: [item stringValue]];
                }
                
                if ([@"CNT" isEqualToString: [item name]]) {
                    [model setCNT: [item stringValue]];
                }
                
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
        }
    }
    
    return array;
}

@end


