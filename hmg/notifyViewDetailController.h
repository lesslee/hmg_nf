//
//  notifyViewDetailController.h
//  hmg
//
//  Created by Hongxianyu on 16/2/24.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "XLForm.h"
#import "XLFormViewController.h"
#import "MBProgressHUDManager.h"

@interface notifyViewDetailController :XLFormViewController<ServiceHelperDelgate,UIDocumentInteractionControllerDelegate>
{
    MBProgressHUDManager *HUDManager;

}


@property (nonatomic ,strong) NSString *boardId;
@property (nonatomic ,strong) NSString *seq;

@property ServiceHelper *serviceHelper;

@end
