//
//  STORE_FLOW_SUMMARY.m
//  hmg
//
//  Created by Lee on 15/6/18.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "STORE_FLOW_SUMMARY.h"
#import "GDataXMLNode.h"
@implementation STORE_FLOW_SUMMARY
@synthesize DEPT_ID=_DEPT_ID;
@synthesize DEPT_NM=_DEPT_NM;
@synthesize QSYLX=_QSYLX;
@synthesize QLYLX=_QLYLX;
@synthesize QYYLX=_QYYLX;
@synthesize DYLX=_DYLX;
@synthesize PJLX=_PJLX;
@synthesize QUANTITY=_QUANTITY;

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
        STORE_FLOW_SUMMARY *model=[[STORE_FLOW_SUMMARY alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"DEPT_ID" isEqualToString:[item name]]) {
                    [model setDEPT_ID:[item stringValue]];
                }
                if ([@"DEPT_NM" isEqualToString:[item name]]) {
                    [model setDEPT_NM:[item stringValue]];
                }
                if ([@"QSYLX" isEqualToString:[item name]]) {
                    [model setQSYLX:[item stringValue]];
                }
                if ([@"QLYLX" isEqualToString:[item name]]) {
                    [model setQLYLX:[item stringValue]];
                }
                if ([@"QYYLX" isEqualToString:[item name]]) {
                    [model setQYYLX:[item stringValue]];
                }
                if ([@"DYLX" isEqualToString:[item name]]) {
                    [model setDYLX:[item stringValue]];
                }
                if ([@"PJLX" isEqualToString:[item name]]) {
                    [model setPJLX:[item stringValue]];
                }
                if ([@"QUANTITY" isEqualToString:[item name]]) {
                    [model setQUANTITY:[item stringValue]];
                }
            }
            
            [array addObject:model];
            
        }
    }
    return array;
}

@end
