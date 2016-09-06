//
//  ReportUser.m
//  hmg
//
//  Created by Hongxianyu on 16/2/29.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ReportUser.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"
@implementation ReportUser

@synthesize OUT_RESULT = _OUT_RESULT;
@synthesize CUSTOM_ID = _CUSTOMER_ID;
@synthesize CUSTOM_TYPE = _CUSTOMER_TYPE;
@synthesize CUSTOM_NM = _CUSTOMER_NM;
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
        ReportUser *model = [[ReportUser alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model setOUT_RESULT:[item stringValue]];
                }
                if ([@"CUSTOMER_ID" isEqualToString: [item name]]) {
                    [model setCUSTOM_ID: [item stringValue]];
                }
                if ([@"CUSTOMER_NM" isEqualToString: [item name]]) {
                    [model setCUSTOM_NM: [item stringValue]];
                }
                if ([@"CUSTOMER_TYPE" isEqualToString: [item name]]) {
                    [model setCUSTOM_TYPE: [item stringValue]];
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
