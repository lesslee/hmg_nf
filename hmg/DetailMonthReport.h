//
//  DetailMonthReport.h
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "XLFormViewController.h"
#import "storeMonthViewController.h"

#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
@interface DetailMonthReport : XLFormViewController<PassMonthTrendValueDelegate,ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}

@property ServiceHelper *serviceHelper;
@property XLFormDescriptor * formDescriptor;
@property XLFormSectionDescriptor * section;
@property XLFormRowDescriptor * row;
@end

