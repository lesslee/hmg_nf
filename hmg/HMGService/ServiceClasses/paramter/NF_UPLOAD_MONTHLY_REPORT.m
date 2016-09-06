//
//  NF_UPLOAD_MONTHLY_REPORT.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "NF_UPLOAD_MONTHLY_REPORT.h"

@implementation NF_UPLOAD_MONTHLY_REPORT
@synthesize IN_EMP_NO=_IN_EMP_NO;
@synthesize IN_STORE_ID=_IN_STORE_ID;
@synthesize IN_DEPT_CD=_IN_DEPT_CD;
@synthesize IN_PRODUCT_ID=_IN_PRODUCT_ID;
@synthesize IN_INVENTORY=_IN_INVENTORY;
@synthesize IN_SALES_QTY = _IN_SALES_QTY;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_EMP_NO=[aDecoder decodeObjectForKey:@"IN_EMP_NO"];
        _IN_STORE_ID=[aDecoder decodeObjectForKey:@"IN_STORE_ID"];
        _IN_DEPT_CD=[aDecoder decodeObjectForKey:@"IN_DEPT_CD"];
        _IN_PRODUCT_ID=[aDecoder decodeObjectForKey:@"IN_PRODUCT_ID"];
        _IN_INVENTORY=[aDecoder decodeObjectForKey:@"IN_INVENTORY"];
         _IN_SALES_QTY=[aDecoder decodeObjectForKey:@"IN_SALES_QTY"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_STORE_ID forKey:@"IN_STORE_ID"];
    [aCoder encodeObject:_IN_PRODUCT_ID forKey:@"IN_PRODUCT_ID"];
    [aCoder encodeObject:_IN_DEPT_CD forKey:@"IN_DEPT_CD"];
    [aCoder encodeObject:_IN_INVENTORY forKey:@"IN_INVENTORY"];
    [aCoder encodeObject:_IN_EMP_NO forKey:@"IN_EMP_NO"];
    [aCoder encodeObject:_IN_SALES_QTY forKey:@"IN_SALES_QTY"];
    
}

@end
