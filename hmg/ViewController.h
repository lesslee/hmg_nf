//
//  ViewController.h
//  hmg
//
//  Created by Lee on 15/3/23.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUDManager.h"
#import "ServiceHelper.h"
@interface ViewController : UIViewController<ServiceHelperDelgate>
{
    MBProgressHUDManager *HUDManager;
    NSTimer *timer;
    long long expectedLength;
    long long currentLength;
}
//@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)loginHandle:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *loginId;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UISwitch *rememberPassword;


@end

