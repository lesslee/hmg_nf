//
//  STORE_RANK_SUMMARY.m
//  hmg
//
//  Created by Lee on 15/6/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "STORE_RANK_SUMMARY.h"
#import "GDataXMLNode.h"
@implementation STORE_RANK_SUMMARY
@synthesize CITY=_CITY;
@synthesize ECONOMIC_RANK=_ECONOMIC_RANK;
@synthesize STORE_COUNT=_STORE_COUNT;
@synthesize CITY_FLOW=_CITY_FLOW;
@synthesize ZHANBI=_ZHANBI;



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
        STORE_RANK_SUMMARY *model=[[STORE_RANK_SUMMARY alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"CITY" isEqualToString:[item name]]) {
                    [model setCITY:[item stringValue]];
                }
                if ([@"ECONOMIC_RANK" isEqualToString:[item name]]) {
                    [model setECONOMIC_RANK:[item stringValue]];
                }
                if ([@"STORE_COUNT" isEqualToString:[item name]]) {
                    [model setSTORE_COUNT:[item stringValue]];
                }
                if ([@"CITY_FLOW" isEqualToString:[item name]]) {
                    [model setCITY_FLOW:[item stringValue]];
                }
            }
            
            [array addObject:model];
        }
    }
    return array;
}



@end
