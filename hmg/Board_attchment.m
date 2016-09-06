//
//  Board_attchment.m
//  hmg
//
//  Created by Hongxianyu on 16/2/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "Board_attchment.h"
#import "CommonResult.h"
#import "GDataXMLNode.h"
@implementation Board_attchment
@synthesize OUT_RESULT = _OUT_RESULT;
@synthesize OUT_RESULT_NM = _OUT_RESULT_NM;
@synthesize FILENAME = _FILENAME;
@synthesize DOWNLOAD_URL = _DOWNLOAD_URL;


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
        Board_attchment *model = [[Board_attchment alloc]init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children = [item children];
            for (GDataXMLNode *item in children) {
                if ([@"OUT_RESULT" isEqualToString:[item name]]) {
                    [model setOUT_RESULT:[item stringValue]];
                }
                if ([@"OUT_RESULT_NM" isEqualToString: [item name]]) {
                    [model setOUT_RESULT_NM: [item stringValue]];
                }
                if ([@"FILENAME" isEqualToString: [item name]]) {
                    [model setFILENAME: [item stringValue]];
                }
                if ([@"DOWNLOAD_URL" isEqualToString: [item name]]) {
                    [model setDOWNLOAD_URL: [item stringValue]];
                }
                
            }
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
        }
    }
    
    return array;
}



@end
