//
//  StoreFlowUser.m
//  hmg
//
//  Created by Hongxianyu on 16/3/10.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "StoreFlowUser.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"
@implementation StoreFlowUser

@synthesize OUT_RESULT = _OUT_RESULT;
@synthesize REPORT_LOGO = _REPORT_LOGO;
@synthesize REPORT_FLOW = _REPORT_FLOW;
@synthesize REPORT_MONTH = _REPORT_MONTH;

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
        StoreFlowUser *model = [[StoreFlowUser alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model setOUT_RESULT:[item stringValue]];
                }
                if ([@"REPORT_LOGO" isEqualToString: [item name]]) {
                    [model setREPORT_LOGO: [item stringValue]];
                }
                if ([@"REPORT_FLOW" isEqualToString: [item name]]) {
                    [model setREPORT_FLOW: [item stringValue]];
                }
                
                if ([@"REPORT_MONTH" isEqualToString: [item name]]) {
                    [model setREPORT_MONTH: [item stringValue]];
                }
                
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
        }
    }
    
    return array;
}

@end


