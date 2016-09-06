//
//  STORE_VISIT_SUMMARY.m
//  hmg
//
//  Created by Lee on 15/6/18.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "STORE_VISIT_SUMMARY.h"
#import "GDataXMLNode.h"
@implementation STORE_VISIT_SUMMARY
@synthesize AREA_NM=_AREA_NM;
@synthesize DEPT_NM=_DEPT_NM;
@synthesize EMP_NM=_EMP_NM;
@synthesize USER_ID=_USER_ID;
@synthesize REPORT_COUNT=_REPORT_COUNT;

@synthesize DYBF=_DYBF;
@synthesize KF=_KF;

@synthesize JD=_JD;

@synthesize HD=_HD;
@synthesize PX=_PX;
@synthesize CLGS=_CLGS;
@synthesize RC=_RC;
@synthesize HY=_HY;

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
        STORE_VISIT_SUMMARY *model=[[STORE_VISIT_SUMMARY alloc] init];
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
                if ([@"USER_ID" isEqualToString:[item name]]) {
                    [model setUSER_ID:[item stringValue]];
                }
                if ([@"REPORT_COUNT" isEqualToString:[item name]]) {
                    [model setREPORT_COUNT:[item stringValue]];
                }
                if ([@"DYBF" isEqualToString:[item name]]) {
                    [model setDYBF:[item stringValue]];
                }
                if ([@"KF" isEqualToString:[item name]]) {
                    [model setKF:[item stringValue]];
                }
                if ([@"JD" isEqualToString:[item name]]) {
                    [model setJD:[item stringValue]];
                }
                if ([@"HD" isEqualToString:[item name]]) {
                    [model setHD:[item stringValue]];
                }
                if ([@"PX" isEqualToString:[item name]]) {
                    [model setPX:[item stringValue]];
                }
                if ([@"CLGS" isEqualToString:[item name]]) {
                    [model setCLGS:[item stringValue]];
                }
                if ([@"RC" isEqualToString:[item name]]) {
                    [model setRC:[item stringValue]];
                }
                if ([@"HY" isEqualToString:[item name]]) {
                    [model setHY:[item stringValue]];
                }
            }
            
            [array addObject:model];
            
        }
        
        
    }
    return array;
}

@end
