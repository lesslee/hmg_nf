//
//  DateSelector_A.h
//  hmg
//
//  Created by Lee on 15/7/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "XLForm.h"
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "ReportDetailDelegate.h"
@interface DateSelector_A : XLFormViewController
{
    MBProgressHUDManager *HUDManager;
}
@property NSObject<ReportDetailDelegate> *delegate;
@end
