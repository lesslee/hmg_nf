//
//  ProuctViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/4/28.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand1.h"
#import "WeekViewController.h"
#import "prouctSection.h"
#import "Prouct.h"
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
@interface ProuctViewController : UIViewController<ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
}

@property ServiceHelper *serviceHelper;
@end
