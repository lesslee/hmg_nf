//
//  Common.m
//  hmg
//
//  Created by Lee on 15/5/13.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"  
#import "MBProgressHUDManager.h"

@implementation Common

-(id) initWithView:(UIView *)view
{
    if (self=[super init]) {
        self.view=view;
    }
    return self;
}

-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            
                        //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
                        //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
                        //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //<span style="font-family: Arial, Helvetica, sans-serif;">MBProgressHUD为第三方库，不需要可以省略或使用AlertView</span>
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = NSLocalizedString(@"当前网络不可用,请检查网络连接!", nil);
        
            [hud hide:YES afterDelay:3];
            return NO;
        
    }
    
    return isExistenceNetwork;
}


@end
