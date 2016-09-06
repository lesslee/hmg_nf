//
//  ProuctTableViewController.h
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "XLFormRowDescriptor.h"
#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "MBProgressHUDManager.h"
#import "prouctSection.h"

@interface ProuctTableViewController :UIViewController<XLFormRowDescriptorViewController,UITableViewDataSource,UITableViewDelegate,ServiceHelperDelgate>

{
    MBProgressHUDManager *HUDManager;
}
@property ServiceHelper *serviceHelper;

@property (nonatomic,weak) prouctSection *productModel1;
@end
