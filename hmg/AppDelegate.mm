    //
    //  AppDelegate.m
    //  hmg
    //
    //  Created by Lee on 15/3/23.
    //  Copyright (c) 2015年 com.lz. All rights reserved.
    //

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>



@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize userInfo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
        //启动图片停留时间2秒
        //[UIView setAnimationDuration:1.0];
    
        //1.初始化ShareSDK应用,字符串"5559f92aa230"换成http://www.mob.com/后台申请的ShareSDK应用的Appkey
    [ShareSDK registerApp:@"fdacc2ba8c90"];
    
        //2. 初始化社交平台
    [self initializePlat];
    
    
    _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"mMR3YhDs6LqGqFGjS9pMKrorNK95ksfn"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    
    [NSThread sleepForTimeInterval:1.0];
    [_window makeKeyAndVisible];
    
        //    [[IQKeyboardManager sharedManager] setEnable:YES];
        //    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
        //
        //    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
        //
        //
        //    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
        //
        //    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    return YES;
}

-(void)initializePlat{
        //连接邮件
    [ShareSDK connectMail];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
