//
//  ReportDetailViewController.h
//  hmg
//
//  Created by Lee on 15/4/14.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "XLForm.h"
#import "XLFormViewController.h"
#import "ReportDetailDelegate.h"
#import "MBProgressHUDManager.h"
#import "QueryReportViewController.h"
@interface ReportDetailViewController : XLFormViewController<ServiceHelperDelgate,UIDocumentInteractionControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
}

@property(nonatomic,strong)NSString *reportId;

@property ServiceHelper *serviceHelper;
@property(nonatomic, strong)NSString *inpdtm;

@end
