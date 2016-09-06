//
//  addMonthReportViewController.h
//  hmg
//
//  Created by hongxianyu on 2016/8/16.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"

@interface addMonthReportViewController : XLFormViewController <ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}

@property ServiceHelper *serviceHelper;

@property XLFormDescriptor * formDescriptor;
@property XLFormSectionDescriptor * section;
@property XLFormRowDescriptor * row;
@end
