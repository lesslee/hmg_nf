//
//  NF_SALESREPORT_QUERY.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "NF_SALESREPORT_QUERY.h"

@implementation NF_SALESREPORT_QUERY
@synthesize IN_EMP_NO=_IN_EMP_NO;
@synthesize IN_MONTH=_IN_MONTH;
@synthesize IN_DEPT_CD=_IN_DEPT_CD;
@synthesize IN_CURRENT_PAGE=_IN_CURRENT_PAGE;
@synthesize IN_PAGE_SIZE=_IN_PAGE_SIZE;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_EMP_NO=[aDecoder decodeObjectForKey:@"IN_EMP_NO"];
        _IN_MONTH=[aDecoder decodeObjectForKey:@"IN_MONTH"];
        _IN_DEPT_CD=[aDecoder decodeObjectForKey:@"IN_DEPT_CD"];
        _IN_CURRENT_PAGE=[aDecoder decodeObjectForKey:@"IN_CURRENT_PAGE"];
        _IN_PAGE_SIZE=[aDecoder decodeObjectForKey:@"IN_PAGE_SIZE"];

    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_PAGE_SIZE forKey:@"IN_PAGE_SIZE"];
    [aCoder encodeObject:_IN_CURRENT_PAGE forKey:@"IN_CURRENT_PAGE"];
    [aCoder encodeObject:_IN_DEPT_CD forKey:@"IN_DEPT_CD"];
    [aCoder encodeObject:_IN_MONTH forKey:@"IN_MONTH"];
    [aCoder encodeObject:_IN_EMP_NO forKey:@"IN_EMP_NO"];
   
}

@end
