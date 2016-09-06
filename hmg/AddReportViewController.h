//
//  AddReportViewController.h
//  hmg
//
//  Created by Lee on 15/3/26.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"


@interface AddReportViewController : XLFormViewController <ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}

@property ServiceHelper *serviceHelper;
@property(nonatomic,strong)NSString *reportId;
@property XLFormDescriptor * formDescriptor;
@property XLFormSectionDescriptor * section;
@property XLFormRowDescriptor * row;
@end
