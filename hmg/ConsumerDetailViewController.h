//
//  ConsumerDetailViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "XLForm.h"
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"
@interface ConsumerDetailViewController :XLFormViewController<ServiceHelperDelgate,UIDocumentInteractionControllerDelegate>
{
    MBProgressHUDManager *HUDManager;
    
}
@property ServiceHelper *serviceHelper;

@end


