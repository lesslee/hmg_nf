//
//  ReportDetailModel.m
//  hmg
//
//  Created by Lee on 15/4/14.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ReportDetailModel.h"
#import "GDataXMLNode.h"

@implementation ReportDetailModel
@synthesize ID=_ID;
@synthesize AGENT_NM=_AGENT_NM;
@synthesize STORE_NM=_STORE_NM;
@synthesize PRODUCT_NM=_PRODUCT_NM;
@synthesize PRODUCT_ID = _PRODUCT_ID;
@synthesize VISIT_PURPOSE=_VISIT_PURPOSE;
@synthesize VISIT_PERSON=_VISIT_PERSON;
@synthesize VISIT_PERSON_TEL=_VISIT_PERSON_TEL;
@synthesize VISIT_PERSON_GH=_VISIT_PERSON_GH;
@synthesize RMK=_RMK;
@synthesize VISIT_PLAN = _VISIT_PLAN;
@synthesize INVENTORY = _INVENTORY;
@synthesize UPLOAD_PHOTO_ID=_UPLOAD_PHOTO_ID;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    GDataXMLDocument *document;
    if ([data isKindOfClass:[NSString class]]) {
        data=[data stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"xmlns=\"%@\"",name] withString:@""];
        document= [[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    } else {
        document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }
    
    if (error) {
        
        return array;
    }
    
    NSString *searchStr=[NSString stringWithFormat:@"//%@",name];
    GDataXMLElement *rootNode =[document rootElement];
    NSArray *childs = [rootNode nodesForXPath:searchStr error:nil];
    for (GDataXMLNode *item in childs) {
        
        [array addObjectsFromArray:[self childsNodeToDictionary:item]];
    }
    
    return array;
    
}

-(NSMutableArray *)childsNodeToDictionary:(GDataXMLNode *)node
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *childs =[node children];
    for(GDataXMLNode *item in childs){
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"ID" isEqualToString:[item name]]) {
                    [self setID:[item stringValue]];
                }
                if ([@"AGENT_NM" isEqualToString:[item name]]) {
                    [self setAGENT_NM:[item stringValue]];
                }
                if ([@"STORE_NM" isEqualToString:[item name]]) {
                    [self setSTORE_NM:[item stringValue]];
                }
                if ([@"PRODUCT_NM" isEqualToString:[item name]]) {
                    [self setPRODUCT_NM:[item stringValue]];
                }
                if ([@"PRODUCT_ID" isEqualToString:[item name]]) {
                    [self setPRODUCT_ID:[item stringValue]];
                }
                if ([@"VISIT_PURPOSE" isEqualToString:[item name]]) {
                    [self setVISIT_PURPOSE:[item stringValue]];
                }
                if ([@"VISIT_PERSON" isEqualToString:[item name]]) {
                    [self setVISIT_PERSON:[item stringValue]];
                }
                if ([@"VISIT_PERSON_TEL" isEqualToString:[item name]]) {
                    [self setVISIT_PERSON_TEL:[item stringValue]];
                }
                if ([@"VISIT_PERSON_GH" isEqualToString:[item name]]) {
                    [self setVISIT_PERSON_GH:[item stringValue]];
                }
                if ([@"RMK" isEqualToString:[item name]]) {
                    [self setRMK:[item stringValue]];
                }
                
                if ([@"INVENTORY" isEqualToString:[item name]]) {
                    [self setINVENTORY:[item stringValue]];
                }
                
                if ([@"VISIT_PLAN" isEqualToString:[item name]]) {
                    [self setVISIT_PLAN:[item stringValue]];
                }
                if ([@"UPLOAD_PHOTO_ID" isEqualToString:[item name]]) {
                    [self setUPLOAD_PHOTO_ID:[item stringValue]];
                }
            }
            NSLog(@"%@",item.stringValue);
            [array addObject:self];
        }
        
        
    }
    return array;
}


@end
