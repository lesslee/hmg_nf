//
//  File.m
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "File.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"
@implementation File
@synthesize FILE_SEQ = _FILE_SEQ;
@synthesize FILE_NM1 = _FILE_NM1;
@synthesize FILE_NM2 = _FILE_NM2;
@synthesize FILE_PATH = _FILE_PATH;
@synthesize OUT_RESULT = _OUT_RESULT;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    if (error) {
        return array;
    }
    
    
    NSString *searchStr = [NSString stringWithFormat:@"//%@",name];
    GDataXMLElement *rootNode = [document rootElement];
    
    NSArray *childs = [rootNode nodesForXPath:searchStr error:nil];
    for (GDataXMLNode *item in childs){
        [array addObjectsFromArray:[self childsNodeToDictionary:item]];
        
    }
    return array;
    
}

-(NSMutableArray *)childsNodeToDictionary:(GDataXMLNode *)node
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *childs =[node children];
    
    for (GDataXMLNode *item in childs) {
        File *model2 = [[File alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"FILE_SEQ" isEqualToString:[item name]]) {
                    [model2 setFILE_SEQ:[item stringValue]];
                }
                if ([@"FILE_PATH" isEqualToString: [item name]]) {
                    [model2 setFILE_PATH: [item stringValue]];
                }
                if ([@"FILE_NM1" isEqualToString:[item name]]) {
                    [model2 setFILE_NM1:[item stringValue]];
                }
                
                if ([@"FILE_NM2" isEqualToString: [item name]]) {
                    [model2 setFILE_NM2:[item stringValue]];
                }
                
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model2 setOUT_RESULT:[item stringValue]];
                }
                
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model2];
        }
    }
    
    return array;
}


@end

