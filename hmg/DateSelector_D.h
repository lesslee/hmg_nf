//
//  DateSelector_D.h
//  hmg
//
//  Created by Hongxianyu on 16/4/19.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLForm.h"
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "weekendDelegate.h"
@interface DateSelector_D : XLFormViewController
{
    MBProgressHUDManager *HUDManager;
}
@property NSObject<weekendDelegate> *delegate;
@end
