//
//  ObjectToXML.h
//  HMClient
//
//  Created by Lee on 15/1/20.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectToXML : NSObject

+(NSString *)convert:(id)obj;

+(NSString *)methodName:(id)obj;

@end
