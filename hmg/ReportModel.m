//
//  ReportModel.m
//  hmg
//
//  Created by Lee on 15/4/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ReportModel.h"
#import "GDataXMLNode.h"
@implementation ReportModel
@synthesize ID=_ID;
@synthesize COUNTRYANDCITY=_COUNTRYANDCITY;
@synthesize INP_DTM=_INP_DTM;
@synthesize RMK=_RMK;
@synthesize DEPT_NM=_DEPT_NM;
@synthesize EMP_NM=_EMP_NM;
@synthesize AGENT_NM=_AGENT_NM;
@synthesize STORE_NM=_STORE_NM;
@synthesize AREA_NM=_AREA_NM;
@synthesize PRODUCT_NM=_PRODUCT_NM;
@synthesize VISIT_PURPOSE=_VISIT_PURPOSE;
@synthesize TOTAL_RECORDS=_TOTAL_RECORDS;
@synthesize CUSTOMER_ID = _CUSTOMER_ID;
@synthesize EMP_NO = _EMP_NO;

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
        ReportModel *model=[[ReportModel alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"ID" isEqualToString:[item name]]) {
                    [model setID:[item stringValue]];
                }
                if ([@"COUNTRYANDCITY" isEqualToString:[item name]]) {
                    [model setCOUNTRYANDCITY:[item stringValue]];
                }
                if ([@"INP_DTM" isEqualToString:[item name]]) {
                    [model setINP_DTM:[item stringValue]];
                }
                if ([@"RMK" isEqualToString:[item name]]) {
                    [model setRMK:[item stringValue]];
                }
                if ([@"DEPT_NM" isEqualToString:[item name]]) {
                    [model setDEPT_NM:[item stringValue]];
                }
                if ([@"EMP_NM" isEqualToString:[item name]]) {
                    [model setEMP_NM:[item stringValue]];
                }
                if ([@"AGENT_NM" isEqualToString:[item name]]) {
                    [model setAGENT_NM:[item stringValue]];
                }
                if ([@"STORE_NM" isEqualToString:[item name]]) {
                    [model setSTORE_NM:[item stringValue]];
                }
                if ([@"AREA_NM" isEqualToString:[item name]]) {
                    [model setAREA_NM:[item stringValue]];
                }
                if ([@"PRODUCT_NM" isEqualToString:[item name]]) {
                    [model setPRODUCT_NM:[item stringValue]];
                }
                if ([@"VISIT_PURPOSE" isEqualToString:[item name]]) {
                    [model setVISIT_PURPOSE:[item stringValue]];
                }
                if ([@"TOTAL_RECORDS" isEqualToString:[item name]]) {
                    [model setTOTAL_RECORDS:[item stringValue]];
                }
                if ([@"EMP_NO" isEqualToString:[item name]]) {
                    [model setEMP_NO:[item stringValue]];
                }
                if ([@"CUSTOMER_ID" isEqualToString:[item name]]) {
                    [model setCUSTOMER_ID:[item stringValue]];
                }
                
            }
            
            NSLog(@"%@",item.stringValue);
            if(model.ID!=nil)
            [array addObject:model];
        }
    }
    return array;
}


@end
