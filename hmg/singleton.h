//
//  singleton.h
//  singleTest
//
//  Created by sky on 16/4/12.
//  Copyright © 2016年 vincee. All rights reserved.
/**
 帮助实现单例类
 */

#define singleton_interface(className) +(className *)shared##className;\
-(void)destroy;

#if __has_feature(objc_arc)//如果是arc
#define singleton_implementation(className) \
static className *_instance;\
static dispatch_once_t dispatchOnce;\
static dispatch_once_t onceToken; \
+(id)shared##className{\
if(!_instance){\
_instance=[[self alloc]init];\
}\
return _instance;\
}\
+(id)allocWithZone:(struct _NSZone *)zone{\
dispatch_once(&dispatchOnce, ^{\
_instance=[super allocWithZone:zone];\
});\
return _instance;\
}\
-(id)init \
{ \
dispatch_once(&onceToken, ^{ \
_instance = [super init]; \
}); \
return _instance; \
} \
-(id)copyWithZone:(struct _NSZone *)zone\
{ \
return _instance; \
} \
-(id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
return _instance; \
}\
-(void)destroy\
{\
 _instance = nil;\
 dispatchOnce = 0;\
 onceToken = 0;\
}\

#else
//...
#endif

