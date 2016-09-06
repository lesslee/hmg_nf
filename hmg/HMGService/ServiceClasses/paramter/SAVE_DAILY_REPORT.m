//
//  SAVE_DAILY_REPORT.m
//  hmg
//
//  Created by Lee on 15/5/5.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "SAVE_DAILY_REPORT.h"

@implementation SAVE_DAILY_REPORT
@synthesize IN_EMP_NO=_IN_EMP_NO;
@synthesize IN_PRODUCT_ID=_IN_PRODUCT_ID;
@synthesize IN_AGENT_ID=_IN_AGENT_ID;
@synthesize IN_STORE_ID=_IN_STORE_ID;
@synthesize IN_VISIT_PURPOSE=_IN_VISIT_PURPOSE;
@synthesize IN_VISIT_PERSON=_IN_VISIT_PERSON;
@synthesize IN_VISIT_PERSON_TEL=_IN_VISIT_PERSON_TEL;
@synthesize IN_VISIT_PERSON_GH=_IN_VISIT_PERSON_GH;
@synthesize IN_RMK=_IN_RMK;
@synthesize IN_TODAY_OR_YESTODAY=_IN_TODAY_OR_YESTODAY;
@synthesize IN_INVENTORY=_IN_INVENTORY;
@synthesize IN_VISIT_PLAN=_IN_VISIT_PLAN;
@synthesize IN_VISIT_TIME=_IN_VISIT_TIME;


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_EMP_NO=[aDecoder decodeObjectForKey:@"IN_EMP_NO"];
        _IN_PRODUCT_ID=[aDecoder decodeObjectForKey:@"IN_PRODUCT_ID"];
        _IN_AGENT_ID=[aDecoder decodeObjectForKey:@"IN_AGENT_ID"];
        _IN_STORE_ID=[aDecoder decodeObjectForKey:@"IN_STORE_ID"];
        _IN_VISIT_PURPOSE=[aDecoder decodeObjectForKey:@"IN_VISIT_PURPOSE"];
        _IN_VISIT_PERSON=[aDecoder decodeObjectForKey:@"IN_VISIT_PERSON"];
        _IN_VISIT_PERSON_TEL=[aDecoder decodeObjectForKey:@"IN_VISIT_PERSON_TEL"];
        _IN_VISIT_PERSON_GH=[aDecoder decodeObjectForKey:@"IN_VISIT_PERSON_GH"];
        _IN_RMK=[aDecoder decodeObjectForKey:@"IN_RMK"];
        _IN_TODAY_OR_YESTODAY=[aDecoder decodeObjectForKey:@"IN_TODAY_OR_YESTODAY"];
        _IN_INVENTORY=[aDecoder decodeObjectForKey:@"IN_INVENTORY"];
        _IN_VISIT_PLAN=[aDecoder decodeObjectForKey:@"IN_VISIT_PLAN"];
        _IN_VISIT_TIME=[aDecoder decodeObjectForKey:@"IN_VISIT_TIME"];


    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_EMP_NO forKey:@"IN_EMP_NO"];
    [aCoder encodeObject:_IN_PRODUCT_ID forKey:@"IN_PRODUCT_ID"];
    [aCoder encodeObject:_IN_AGENT_ID forKey:@"IN_AGENT_ID"];
    [aCoder encodeObject:_IN_STORE_ID forKey:@"IN_STORE_ID"];
    [aCoder encodeObject:_IN_VISIT_PURPOSE forKey:@"IN_VISIT_PURPOSE"];
    [aCoder encodeObject:_IN_VISIT_PERSON forKey:@"IN_VISIT_PERSON"];
    [aCoder encodeObject:_IN_VISIT_PERSON_TEL forKey:@"IN_VISIT_PERSON_TEL"];
    [aCoder encodeObject:_IN_VISIT_PERSON_GH forKey:@"IN_VISIT_PERSON_GH"];
    [aCoder encodeObject:_IN_RMK forKey:@"IN_RMK"];
    [aCoder encodeObject:_IN_TODAY_OR_YESTODAY forKey:@"IN_TODAY_OR_YESTODAY"];
    [aCoder encodeObject:_IN_VISIT_PLAN forKey:@"IN_VISIT_PLAN"];
    [aCoder encodeObject:_IN_INVENTORY forKey:@"IN_INVENTORY"];
    [aCoder encodeObject:_IN_VISIT_TIME forKey:@"IN_VISIT_TIME"];
}

@end
