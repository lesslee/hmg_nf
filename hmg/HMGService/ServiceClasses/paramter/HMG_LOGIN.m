//
//  HMG_LOGIN.m
//  hmg
//
//  Created by Lee on 15/3/25.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "HMG_LOGIN.h"

@implementation HMG_LOGIN
@synthesize IN_LOGIN_ID =_IN_LOGIN_ID;
@synthesize IN_LOGIN_PW=_IN_LOGIN_PW;

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _IN_LOGIN_ID=[aDecoder decodeObjectForKey:@"IN_LOGIN_ID"];
        _IN_LOGIN_PW=[aDecoder decodeObjectForKey:@"IN_LOGIN_PW"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IN_LOGIN_ID forKey:@"IN_LOGIN_ID"];
    [aCoder encodeObject:_IN_LOGIN_PW forKey:@"IN_LOGIN_PW"];
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"HMG_LOGIN<IN_LOGIN_ID=%@,IN_LOGIN_PW=%@>",_IN_LOGIN_ID,_IN_LOGIN_PW];
}

@end
