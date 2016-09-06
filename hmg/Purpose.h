//
//  Purpose.h
//  hmg
//
//  Created by Lee on 15/5/5.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purpose : NSObject
@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * NAME;

- (id)initWithID:(NSString *) ID andNAME:(NSString *) NAME;

@end
