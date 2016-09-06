//
//  Common.h
//  hmg
//
//  Created by Lee on 15/5/13.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Common : NSObject

@property UIView *view;

-(id) initWithView:(UIView *) view;

-(BOOL) isConnectionAvailable;

@end
