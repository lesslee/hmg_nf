//
//  MenuViewController.h
//  hmg
//
//  Created by Lee on 15/3/24.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
@interface MenuViewController : UIViewController<ServiceHelperDelgate>
{
MBProgressHUDManager *HUDManager;

}
@property ServiceHelper *serviceHelper;


@end
