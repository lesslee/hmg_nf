//
//  Date.h
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Date : NSObject
@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * NAME;

- (id)initWithID:(NSString *) ID andNAME:(NSString *) NAME;

@end
