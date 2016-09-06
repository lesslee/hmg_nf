//
//  ReportPhoto.m
//  hmg
//
//  Created by Lee on 15/4/15.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ReportPhoto.h"
#import "GDataXMLNode.h"

@implementation ReportPhoto
@synthesize FILE_PATH=_FILE_PATH;
@synthesize FILE_NM1=_FILE_NM1;
@synthesize FILE_NM2=_FILE_NM2;

-(NSString *) description
{
    return [NSString stringWithFormat:@"ReportPhoto<FILE_PATH:%@,FILE_NM1:%@,FILE_NM2:%@>",self.FILE_PATH,self.FILE_NM1,self.FILE_NM2];
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
        ReportPhoto *model=[[ReportPhoto alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"FILE_PATH" isEqualToString:[item name]]) {
                    [model setFILE_PATH:[item stringValue]];
                }
                if ([@"FILE_NM1" isEqualToString:[item name]]) {
                    [model setFILE_NM1:[item stringValue]];
                }
                if ([@"FILE_NM2" isEqualToString:[item name]]) {
                    [model setFILE_NM2:[item stringValue]];
                }
            }
            [array addObject:model];
        }
    }
    return array;
}


@end
