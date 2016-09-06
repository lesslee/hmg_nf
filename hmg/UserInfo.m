//
//  UserInfo.m
//  hmg
//
//  Created by Lee on 15/3/25.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "UserInfo.h"
#import "GDataXMLNode.h"
@implementation UserInfo

@synthesize OUT_RESULT=_OUT_RESULT;
@synthesize OUT_RESULT_NM=_OUT_RESULT_NM;
@synthesize EMP_NO=_EMP_NO;
@synthesize EMP_NM=_EMP_NM;
@synthesize EMP_TYPE=_EMP_TYPE;
@synthesize DEPT_CD=_DEPT_CD;
@synthesize DEPT_NM=_DEPT_NM;
@synthesize V_MONTH=_V_MONTH;

-(NSString *) description
{
    return [NSString stringWithFormat:@"UserInfo<OUT_RESULT=%@,OUT_RESULT_NM=%@,EMP_NO=%@,EMP_NM=%@,DEPT_NM=%@,DEPT_CD=%@,EMP_TYPE=%@,V_MONTH=%@>",_OUT_RESULT,_OUT_RESULT_NM,_EMP_NO,_EMP_NM,_DEPT_NM,_DEPT_CD,_EMP_TYPE,_V_MONTH];
}

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
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [self setOUT_RESULT:[item stringValue]];
                }
                if ([@"OUT_RESULT_NM" isEqualToString:[item name]]) {
                    [self setOUT_RESULT_NM:[item stringValue]];
                }
                if ([@"EMP_NO" isEqualToString:[item name]]) {
                    [self setEMP_NO:[item stringValue]];
                }
                if ([@"EMP_NM" isEqualToString:[item name]]) {
                    [self setEMP_NM:[item stringValue]];
                }
                if ([@"EMP_TYPE" isEqualToString:[item name]]) {
                    [self setEMP_TYPE:[item stringValue]];
                }
                if ([@"DEPT_CD" isEqualToString:[item name]]) {
                    [self setDEPT_CD:[item stringValue]];
                }
                if ([@"DEPT_NM" isEqualToString:[item name]]) {
                    [self setDEPT_NM:[item stringValue]];
                }
                if ([@"V_MONTH" isEqualToString:[item name]]) {
                    [self setV_MONTH:[item stringValue]];
                }
            }
            NSLog(@"%@",item.stringValue);
            [array addObject:self];
        }
        
        
    }
    return array;
}

@end
