//
//  DateSelector_C.h
//  hmg
//
//  Created by Lee on 15/7/17.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "XLForm.h"
#import "XLFormViewController.h"
#import "DateDelegate.h"
#import "MBProgressHUDManager.h"

@interface DateSelector_C : XLFormViewController
{
    MBProgressHUDManager *HUDManager;
}
@property NSObject<DateDelegate> *delegate;

@end
