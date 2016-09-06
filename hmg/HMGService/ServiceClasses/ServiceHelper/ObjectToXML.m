//
//  ObjectToXML.m
//  HMClient
//
//  Created by Lee on 15/1/20.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ObjectToXML.h"
#import <objc/runtime.h>

@implementation ObjectToXML

+(NSString *)convert:(id)obj{
    
    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList([obj class], &outCount);
    
    NSString *xml = [[NSString alloc] initWithFormat:@"" ];
    
    for (i = 0; i< outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id value = [obj valueForKey:key];
        //        NSLog(@"value = %@",value);
        if (value !=nil) {
            if (![value isKindOfClass:[NSString class]]) {
                xml = [xml stringByAppendingFormat:@"%@",[ObjectToXML convert:[obj valueForKey:key]]];
            }
            else
            {
                xml = [xml stringByAppendingFormat:@"<%@>%@</%@>",key,value,key];
            }
        }else
        {
            
            xml = [xml stringByAppendingFormat:@"<%@>%@</%@>",key,@"",key];
        }
    }
    
    xml = [xml stringByAppendingFormat:@""];
    
    free(properties);
    
    return xml;
}


+(NSString *)methodName:(id)obj{
    //    unsigned int outCount,i;
    //    objc_property_t * properties = class_copyPropertyList([obj class], &outCount);
    
    NSString *xml = [[NSString alloc] initWithFormat:@"%@",[obj class] ];
    return xml;
}


@end
