//
//  CommonResult.m
//  hmg
//
//  Created by Lee on 15/5/6.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "CommonResult.h"
#import "GDataXMLNode.h"


@implementation CommonResult
@synthesize OUT_RESULT=_OUT_RESULT;
@synthesize OUT_RESULT_NM=_OUT_RESULT_NM;
@synthesize ID=_ID;


-(NSString *) description
{
    return [NSString stringWithFormat:@"CommonResult<OUT_RESULT:%@,OUT_RESULT_NM:%@,ID:@%@>",self.OUT_RESULT,self.OUT_RESULT_NM,self.ID];
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
                if ([@"ID" isEqualToString:[item name]]) {
                    [self setID:[item stringValue]];
                }
            }
            
            [array addObject:self];
        }
        
        
    }
    return array;
}


@end
