//
//  Prouct.m
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Prouct.h"
#import "GDataXMLNode.h"
@implementation Prouct
@synthesize OUT_RESULT = _OUT_RESULT;
@synthesize PROD_ID=_PROD_ID;
@synthesize PROD_NM=_PROD_NM;
@synthesize TYPE_NM = _TYPE_NM;
@synthesize SPEC =_SPEC;
@synthesize RMSPRICE = _RMSPRICE;
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
        Prouct *model=[[Prouct alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"PROD_ID" isEqualToString:[item name]]) {
                    [model setPROD_ID:[item stringValue]];
                }
                if ([@"PROD_NM" isEqualToString:[item name]]) {
                    [model setPROD_NM:[item stringValue]];
                }
                if ([@"TYPE_NM" isEqualToString:[item name]]) {
                    [model setTYPE_NM:[item stringValue]];
                }
                
                if ([@"SPEC" isEqualToString:[item name]]) {
                    [model setSPEC:[item stringValue]];
                }
                if ([@"RMSPRICE" isEqualToString:[item name]]) {
                    [model setRMSPRICE:[item stringValue]];
                }
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model setOUT_RESULT:[item stringValue]];
                }

            }
            
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
            
        }
        
        
    }
    return array;
}


@end
