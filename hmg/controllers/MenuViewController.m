    //
    //  MenuViewController.m
    //  hmg
    //
    //  Created by Lee on 15/3/24.
    //  Copyright (c) 2015年 com.lz. All rights reserved.
    //

#import "MenuViewController.h"
#import "BFPaperButton.h"
#import "CustomButton.h"
#import "AppDelegate.h"
#import "CommonResult.h"
#import "Common.h"
#import "CP_LOGIN_LOG.h"
#import "SoapHelper.h"
#import "Log.h"
    //ShareSDK头文件
#import <ShareSDK/ShareSDK.h>
#define  Font [UIFont systemFontOfSize:13];

@interface MenuViewController ()
@property (nonatomic, strong) id<ISSShareActionSheet> actionSheet;


    //顶部banner
@property UIImageView *banner;
    //日报录入
@property CustomButton *btn_report_add;
    //日报查询
@property CustomButton *btn_report_query;
    //考勤
@property CustomButton *btn_check_in;
    //HMG公告
@property CustomButton *btn_hmg_notice;
    //HMG公告
@property CustomButton *btn_hmg_addMonth;
    ////consumer公告
    //@property CustomButton *btn_consumer_notice;
    ////报表
    //@property CustomButton *btn_report;
    ////邮箱
    //@property CustomButton *btn_mail;
    ////周末促
    //@property CustomButton *btn_week_prom;
    ////查询促销
    //@property CustomButton *btn_prom_query;
    ////信息采集
    //@property CustomButton *btn_info_collect;
@end

@implementation MenuViewController
id<ISSContainer> container;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self log];
    [self initMenu];
}

-(void) initMenu {
    
    _banner=[[UIImageView alloc] init];
    _banner.image=[UIImage imageNamed:@"nav_bg"];
    _banner.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_banner];
    
    _btn_report_add=[[CustomButton alloc] init];
    [_btn_report_add setTitle:@"日报录入" forState:UIControlStateNormal];
    [_btn_report_add setImage:[UIImage imageNamed:@"nav_icon_03.png"] forState:UIControlStateNormal];
    [_btn_report_add setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#b3d01e" alpha:(1.0f)]] forState:UIControlStateNormal];
    [_btn_report_add setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#b3d01e" alpha:(0.8f)]] forState:UIControlStateHighlighted];
    _btn_report_add.titleLabel.font = Font;
    _btn_report_add.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn_report_add.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btn_report_add.translatesAutoresizingMaskIntoConstraints=NO;
    [_btn_report_add addTarget:self action:@selector(addHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_report_add];
    
    _btn_report_query=[[CustomButton alloc] init];
    [_btn_report_query setTitle:@"日报查询" forState:UIControlStateNormal];
    [_btn_report_query setImage:[UIImage imageNamed:@"nav_icon_06.png"] forState:UIControlStateNormal];
    [_btn_report_query setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#f8664f" alpha:(1.0f)]] forState:UIControlStateNormal];
    [_btn_report_query setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#f8664f" alpha:(0.8f)]] forState:UIControlStateHighlighted];
    _btn_report_query.titleLabel.font = Font;
    _btn_report_query.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn_report_query.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btn_report_query.translatesAutoresizingMaskIntoConstraints=NO;
    
    [_btn_report_query addTarget:self action:@selector(queryHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_report_query];
    
    _btn_check_in=[[CustomButton alloc] init];
    [_btn_check_in setTitle:@"考勤" forState:UIControlStateNormal];
    [_btn_check_in setImage:[UIImage imageNamed:@"nav_icon_10.png"] forState:UIControlStateNormal];
    [_btn_check_in setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#41b6ca" alpha:(1.0f)]] forState:UIControlStateNormal];
    [_btn_check_in setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#41b6ca" alpha:(0.8f)]] forState:UIControlStateHighlighted];    _btn_check_in.titleLabel.font = Font;
    _btn_check_in.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn_check_in.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btn_check_in.translatesAutoresizingMaskIntoConstraints=NO;
    [_btn_check_in addTarget:self action:@selector(gpsHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_check_in];
    
    _btn_hmg_notice=[[CustomButton alloc] init];
    [_btn_hmg_notice setTitle:@"HMG公告" forState:UIControlStateNormal];
    [_btn_hmg_notice setImage:[UIImage imageNamed:@"nav_icon_notify.png"] forState:UIControlStateNormal];
    [_btn_hmg_notice setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#ebb424" alpha:(1.0f)]] forState:UIControlStateNormal];
    [_btn_hmg_notice setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#ebb424" alpha:(0.8f)]] forState:UIControlStateHighlighted];
    _btn_hmg_notice.titleLabel.font = Font;
    _btn_hmg_notice.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn_hmg_notice.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btn_hmg_notice.translatesAutoresizingMaskIntoConstraints=NO;
    [_btn_hmg_notice addTarget:self action:@selector(notifyHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_hmg_notice];
    
    
    _btn_hmg_addMonth=[[CustomButton alloc] init];
    [_btn_hmg_addMonth setTitle:@"门店销售月报" forState:UIControlStateNormal];
    [_btn_hmg_addMonth setImage:[UIImage imageNamed:@"nav_icon_06.png"] forState:UIControlStateNormal];
    [_btn_hmg_addMonth setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#99a4b7" alpha:(1.0f)]] forState:UIControlStateNormal];
    [_btn_hmg_addMonth setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#99a4b7" alpha:(0.8f)]] forState:UIControlStateHighlighted];
    _btn_hmg_addMonth.titleLabel.font = Font;
    _btn_hmg_addMonth.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn_hmg_addMonth.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btn_hmg_addMonth.translatesAutoresizingMaskIntoConstraints=NO;
    [_btn_hmg_addMonth addTarget:self action:@selector(addMonthHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_hmg_addMonth];
    
    
        //    _btn_consumer_notice=[[CustomButton alloc] init];
        //    [_btn_consumer_notice setTitle:@"consumer公告" forState:UIControlStateNormal];
        //    [_btn_consumer_notice setImage:[UIImage imageNamed:@"nav_icon_notify.png"] forState:UIControlStateNormal];
        //    [_btn_consumer_notice setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#3CF44D" alpha:(1.0f)]] forState:UIControlStateNormal];
        //    [_btn_consumer_notice setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#ebb424" alpha:(0.8f)]] forState:UIControlStateHighlighted];
        //    _btn_consumer_notice.titleLabel.font = Font;
        //    _btn_consumer_notice.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _btn_consumer_notice.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    _btn_consumer_notice.translatesAutoresizingMaskIntoConstraints=NO;
        //    [_btn_consumer_notice addTarget:self action:@selector(consumerHandle:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.view addSubview:_btn_consumer_notice];
    
        //    _btn_report=[[CustomButton alloc] init];
        //    [_btn_report setTitle:@"报表" forState:UIControlStateNormal];
        //    [_btn_report setImage:[UIImage imageNamed:@"nav_icon_report.png"] forState:UIControlStateNormal];
        //    [_btn_report setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#9c6be9" alpha:(1.0f)]] forState:UIControlStateNormal];
        //    [_btn_report setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#9c6be9" alpha:(0.8f)]] forState:UIControlStateHighlighted];
        //    _btn_report.titleLabel.font = Font;
        //    _btn_report.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _btn_report.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    _btn_report.translatesAutoresizingMaskIntoConstraints=NO;
        //
        //     [_btn_report addTarget:self action:@selector(reportHandle:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.view addSubview:_btn_report];
        //
        //    _btn_mail=[[CustomButton alloc] init];
        //    [_btn_mail setTitle:@"邮件" forState:UIControlStateNormal];
        //    [_btn_mail setImage:[UIImage imageNamed:@"email.png"] forState:UIControlStateNormal];
        //    [_btn_mail setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#9c6be9" alpha:(1.0f)]] forState:UIControlStateNormal];
        //    [_btn_mail setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#9c6be9" alpha:(0.8f)]] forState:UIControlStateHighlighted];
        //    _btn_mail.titleLabel.font = Font;
        //    _btn_mail.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _btn_mail.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    _btn_mail.translatesAutoresizingMaskIntoConstraints=NO;
        //    [_btn_mail addTarget:self action:@selector(emailHandle:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.view addSubview:_btn_mail];
        //
        //    _btn_week_prom=[[CustomButton alloc] init];
        //    [_btn_week_prom setTitle:@"周末促" forState:UIControlStateNormal];
        //    [_btn_week_prom setImage:[UIImage imageNamed:@"nav_icon_10.png"] forState:UIControlStateNormal];
        //    [_btn_week_prom setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#802254" alpha:(1.0f)]] forState:UIControlStateNormal];
        //    [_btn_week_prom setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#802254" alpha:(0.8f)]] forState:UIControlStateHighlighted];
        //    _btn_week_prom.titleLabel.font = Font;
        //    _btn_week_prom.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _btn_week_prom.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    _btn_week_prom.translatesAutoresizingMaskIntoConstraints=NO;
        //    [_btn_week_prom addTarget:self action:@selector(weekyHandle:) forControlEvents:UIControlEventTouchUpInside];
        //
        //    [self.view addSubview:_btn_week_prom];
        //
        //    _btn_prom_query=[[CustomButton alloc] init];
        //    [_btn_prom_query setTitle:@"查询促销" forState:UIControlStateNormal];
        //    [_btn_prom_query setImage:[UIImage imageNamed:@"nav_icon_10.png"] forState:UIControlStateNormal];
        //    [_btn_prom_query setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#5F9E55" alpha:(1.0f)]] forState:UIControlStateNormal];
        //    [_btn_prom_query setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#ebb424" alpha:(0.8f)]] forState:UIControlStateHighlighted];
        //    _btn_prom_query.titleLabel.font = Font;
        //    _btn_prom_query.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _btn_prom_query.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    _btn_prom_query.translatesAutoresizingMaskIntoConstraints=NO;
        //     [_btn_prom_query addTarget:self action:@selector(weekendHandle:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.view addSubview:_btn_prom_query];
        //
        //    _btn_info_collect=[[CustomButton alloc] init];
        //    [_btn_info_collect setTitle:@"信息采集" forState:UIControlStateNormal];
        //    [_btn_info_collect setImage:[UIImage imageNamed:@"nav_icon_10.png"] forState:UIControlStateNormal];
        //    [_btn_info_collect setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#9c6be9" alpha:(1.0f)]] forState:UIControlStateNormal];
        //    [_btn_info_collect setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#9c6be9" alpha:(0.8f)]] forState:UIControlStateHighlighted];
        //    _btn_info_collect.titleLabel.font = Font;
        //    _btn_info_collect.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _btn_info_collect.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    _btn_info_collect.translatesAutoresizingMaskIntoConstraints=NO;
        //    [_btn_info_collect addTarget:self action:@selector(customerLoctaionHandle:) forControlEvents:UIControlEventTouchUpInside];
        //
        //    [self.view addSubview:_btn_info_collect];
    
        //    NSDictionary *views=NSDictionaryOfVariableBindings(_banner,_btn_report_add,_btn_report_query,_btn_check_in,_btn_hmg_notice,_btn_consumer_notice,_btn_mail,_btn_report,_btn_week_prom,_btn_prom_query,_btn_info_collect);
        //
        //    NSArray *formatStrings=@[@"V:|[_banner(==160)]-2-[_btn_report_add]-2-[_btn_hmg_notice(==_btn_report_add)]-2-[_btn_report(==_btn_hmg_notice)]|",
        //
        //                             @"V:|[_banner(==160)]-2-[_btn_report_query]-2-[_btn_consumer_notice(==_btn_report_query)]-2-[_btn_mail(==_btn_consumer_notice)]|",
        //
        //                             @"V:|[_banner]-2-[_btn_check_in]-2-[_btn_week_prom(==_btn_check_in)]-2-[_btn_prom_query(==_btn_week_prom)]-2-[_btn_info_collect(==_btn_consumer_notice)]|",
        //
        //
        //                             @"H:|[_banner]|",
        //
        //                             @"H:|[_btn_report_add]-2-[_btn_report_query(==_btn_report_add)]-2-[_btn_check_in(==_btn_report_query)]|",
        //
        //                             @"H:|[_btn_hmg_notice]-2-[_btn_consumer_notice(==_btn_hmg_notice)]-2-[_btn_week_prom(==_btn_consumer_notice)]|",
        //
        //                             @"H:|[_btn_hmg_notice]-2-[_btn_consumer_notice(==_btn_hmg_notice)]-2-[_btn_prom_query(==_btn_consumer_notice)]|",
        //
        //
        //                             @"H:|[_btn_report]-2-[_btn_mail(==_btn_report)]-2-[_btn_info_collect(==_btn_mail)]|",
        //
        //                             ];
    
    
    
    NSDictionary *views=NSDictionaryOfVariableBindings(_banner,_btn_report_add,_btn_report_query,_btn_check_in,_btn_hmg_notice,_btn_hmg_addMonth);
    
    NSArray *formatStrings=@[@"V:|[_banner(==160)]-2-[_btn_report_add]-2-[_btn_hmg_notice(==_btn_report_add)]|",
                             
                             @"V:|[_banner(==160)]-2-[_btn_report_query]-2-[_btn_check_in(==_btn_report_query)]|",
                             
                             @"V:|[_banner(==160)]-2-[_btn_report_add]-2-[_btn_hmg_addMonth(==_btn_report_add)]|",
                             
                             @"H:|[_banner]|",
                             
                             @"H:|[_btn_report_add]-2-[_btn_report_query(==_btn_report_add)]|",
                             
                             @"H:|[_btn_hmg_notice]-2-[_btn_hmg_addMonth(_btn_hmg_notice)]-2-[_btn_check_in(==_btn_hmg_addMonth)]|",
                             ];
    
    for (NSString *formatString in formatStrings) {
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString options:0 metrics:nil views:views]];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
        //隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}


    //门店销售月报
-(void)addMonthHandle:(id)sender{
    
    [self performSegueWithIdentifier:@"storeMonthID" sender:self];
}
    //日报录入
- (void)addHandle:(id)sender {
    [self performSegueWithIdentifier:@"reportAddId" sender:self];
}

    //日报查询
- (void)queryHandle:(id)sender {
    [self performSegueWithIdentifier:@"reportQueryId" sender:self];
}

    //考勤
- (void)gpsHandle:(id)sender {
    [self performSegueWithIdentifier:@"gpsId" sender:self];
}

    //数据查询
- (void)reportHandle:(id)sender {
    [self performSegueWithIdentifier:@"dataId" sender:self];
}

    //公告
- (void)notifyHandle:(id)sender {
    [self performSegueWithIdentifier:@"notifyId" sender:self];
}

    //周末促录入
-(void)weekyHandle:(id)sender{
    [self performSegueWithIdentifier:@"weekId" sender:self];
}
    //周末促查询
-(void)weekendHandle:(id)sender{
    [self performSegueWithIdentifier:@"weekendId" sender:self];
}

    //consucomer公告
-(void)consumerHandle:(id)sender{
    [self performSegueWithIdentifier:@"consumerId" sender:self];
}

    //坐标采集
-(void)customerLoctaionHandle:(id)sender{
    
    [self performSegueWithIdentifier:@"customerLoctaionId" sender:self];
    
}


    //邮箱
- (void)emailHandle:(id)sender
{
    
        //1、构造分享内容
        //1.1、要分享的图片（以下分别是网络图片和本地图片的生成方式的示例）
    id<ISSCAttachment> remoteAttachment = [ShareSDKCoreService attachmentWithUrl:@""];
        //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:nil
                                                image:remoteAttachment
                                                title:@""
                                                  url:@"http://www.mob.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
        //1+、创建弹出菜单容器（iPad应用必要，iPhone应用非必要）
        //    id<ISSContainer> container = [ShareSDK container];
        //    [container setIPadContainerWithView:sender
        //                            arrowDirect:UIPopoverArrowDirectionUp];
    
        //2、展现分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                NSLog(@"=== response state :%zi ",state);
                                
                                    //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                    {
                                        //                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送成功"
                                        //                                                                                    message:nil
                                        //                                                                                   delegate:self
                                        //                                                                          cancelButtonTitle:@"确定"
                                        //                                                                          otherButtonTitles:nil, nil];
                                        //                                    [alert show];
                                    [HUDManager showMessage:@"发送成功" duration:1];
                                    }
                                else if (state == SSResponseStateFail)
                                    {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告!"
                                                                                    message:[NSString stringWithFormat:@"警告信息：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    }
                            }];
    
}




-(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
        //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        // String should be 6 or 8 characters
    if ([cString length] < 6)
        {
        return [UIColor clearColor];
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
        {
        cString = [cString substringFromIndex:2];
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
        {
        cString = [cString substringFromIndex:1];
        }
    if ([cString length] != 6)
        {
        return [UIColor clearColor];
        }
    
        // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
        //r
    NSString *rString = [cString substringWithRange:range];
        //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
        //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
        // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}



-(void)log{
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CP_LOGIN_LOG *param=[[CP_LOGIN_LOG alloc] init];
        param.IN_SABEON = appDelegate.userInfo.EMP_NO;
        NSLog(@"%@",param.IN_SABEON);
        
        param.IN_COMPANY = @"HMG";
        
        param.IN_VERSION = @"1.0";
        
        NSLog(@"%@",param.IN_SABEON);
        
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSLog(@"%@",identifierForVendor);
        param.IN_IMEI_CODE = identifierForVendor;
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        NSLog(@"%@",param);
        NSLog(@"%@",paramXml);
        [self.serviceHelper asynServiceMethod:@"CP_LOGIN_LOG" soapMessage:paramXml];
    }
}

-(void) finishSuccessRequest:(NSData *)xml
{
    Log *info1=[[Log alloc] init];
    NSMutableArray *array =[[NSMutableArray alloc] init];
    [array addObjectsFromArray:[info1 searchNodeToArray:xml nodeName:@"NewDataSet"]];
    NSLog(@"%@－－－－－－－－0000000",info1);
    
    if ([info1.OUT_RESULT isEqualToString:@"0"]) {
        [self description];
    }
}
@end
