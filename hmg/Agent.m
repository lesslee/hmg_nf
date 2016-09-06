//
//  Agent.m
//  hmg
//
//  Created by Lee on 15/3/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Agent.h"
#import "GDataXMLNode.h"

@implementation Agent
@synthesize AGENT_ID=_AGENT_ID;
@synthesize AGENT_NM=_AGENT_NM;
@synthesize ADDR = _ADDR;
@synthesize GPS_LAT = _GPS_LAT;
@synthesize GPS_LON = _GPS_LON;
@synthesize TOTAL_RECORDS=_TOTAL_RECORDS;

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
        Agent *model=[[Agent alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"AGENT_ID" isEqualToString:[item name]]) {
                    [model setAGENT_ID:[item stringValue]];
                }
                if ([@"AGENT_NM" isEqualToString:[item name]]) {
                    [model setAGENT_NM:[item stringValue]];
                }
                if ([@"ADDR" isEqualToString:[item name]]) {
                    [model setADDR:[item stringValue]];
                }
                
                if ([@"GPS_LAT" isEqualToString:[item name]]) {
                    [model setGPS_LAT:[item stringValue]];
                }
                if ([@"GPS_LON" isEqualToString:[item name]]) {
                    [model setGPS_LON:[item stringValue]];
                }

                if ([@"TOTAL_RECORDS" isEqualToString:[item name]]) {
                    [model setTOTAL_RECORDS:[item stringValue]];
                }
            }
            
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
            
        }
        
        
    }
    return array;
}


@end
