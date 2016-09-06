//
//  AreaModel.m
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "AreaModel.h"
#import "GDataXMLNode.h"
@implementation AreaModel
@synthesize DEPT_ID=_DEPT_ID;
@synthesize DEPT_NM=_DEPT_NM;

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
        AreaModel *model=[[AreaModel alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"DEPT_ID" isEqualToString:[item name]]) {
                    [model setDEPT_ID:[item stringValue]];
                }
                if ([@"DEPT_NM" isEqualToString:[item name]]) {
                    [model setDEPT_NM:[item stringValue]];
                }
            }
            
            //NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
        }
    }
    return array;
}

@end
