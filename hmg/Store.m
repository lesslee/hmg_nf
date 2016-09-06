//
//  Store.m
//  hmg
//
//  Created by Lee on 15/4/29.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Store.h"
#import "GDataXMLNode.h"
@implementation Store
@synthesize STORE_ID=_STORE_ID;
@synthesize STORE_NM=_STORE_NM;
@synthesize GPS_LON=_GPS_LON;
@synthesize GPS_LAT=_GPS_LAT;
@synthesize TOTAL_RECORDS=_TOTAL_RECORDS;
@synthesize ADDR = _ADDR;
@synthesize IS_MANAGE = _IS_MANAGE;


-(void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:self.STORE_ID forKey:@"STORE_ID"];
    [aCoder encodeObject:self.STORE_NM forKey:@"STORE_NM"];
    [aCoder encodeObject:self.GPS_LON forKey:@"GPS_LON"];
    [aCoder encodeObject:self.GPS_LAT forKey:@"GPS_LAT"];
    [aCoder encodeObject:self.TOTAL_RECORDS forKey:@"TOTAL_RECORDS"];
    [aCoder encodeObject:self.ADDR forKey:@"ADDR"];
    [aCoder encodeObject:self.IS_MANAGE forKey:@"IS_MANAGE"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
    self.STORE_NM = [aDecoder decodeObjectForKey:@"STORE_NM"];
    self.STORE_ID = [aDecoder decodeObjectForKey:@"STORE_ID"];
    self.GPS_LON = [aDecoder decodeObjectForKey:@"GPS_LON"];
    self.GPS_LAT = [aDecoder decodeObjectForKey:@"GPS_LAT"];
    self.TOTAL_RECORDS = [aDecoder decodeObjectForKey:@"TOTAL_RECORDS"];
    self.ADDR = [aDecoder decodeObjectForKey:@"ADDR"];
    self.IS_MANAGE = [aDecoder decodeObjectForKey:@"IS_MANAGE"];

    }
    return self;
}


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
        Store *model=[[Store alloc] init];
        if ([@"table1" isEqualToString:[item name]]) {
            NSArray *children =[item children];
            for (GDataXMLNode *item in children ) {
                if ([@"STORE_ID" isEqualToString:[item name]]) {
                    [model setSTORE_ID:[item stringValue]];
                }
                if ([@"STORE_NM" isEqualToString:[item name]]) {
                    [model setSTORE_NM:[item stringValue]];
                }
                if ([@"IS_MANAGE" isEqualToString:[item name]]) {
                    [model setIS_MANAGE:[item stringValue]];
                }
                if ([@"GPS_LON" isEqualToString:[item name]]) {
                    [model setGPS_LON:[item stringValue]];
                }
                if ([@"GPS_LAT" isEqualToString:[item name]]) {
                    [model setGPS_LAT:[item stringValue]];
                }
                
                if ([@"ADDR" isEqualToString:[item name]]) {
                    [model setADDR:[item stringValue]];
                }
                if ([@"TOTAL_RECORDS" isEqualToString:[item name]]) {
                    [model setTOTAL_RECORDS:[item stringValue]];
                }
            }
            
            NSLog(@"%@",item.stringValue);
            
            [array addObject:model];
        }
    }
    return array;
}

@end
