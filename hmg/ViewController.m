    //
    //  ViewController.m
    //  hmg
    //
    //  Created by Lee on 15/3/23.
    //  Copyright (c) 2015年 com.lz. All rights reserved.
    //

#import "ViewController.h"
#import "HMG_LOGIN.h"
#import "SoapHelper.h"
#import "ServiceHelper.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "Common.h"
#import "CP_LOGIN_LOG.h"
#import "CommonResult.h"
@interface ViewController ()

@end

@implementation ViewController

ServiceHelper *serviceHelper;

NSUserDefaults *userDefaultes;
NSString *empno;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateApp];
    if (!userDefaultes) {
        userDefaultes = [NSUserDefaults standardUserDefaults];
    }
    
    serviceHelper = [[ServiceHelper alloc] initWithDelegate:self];
    
    
        //设置背景图片
    UIImage *imageBg=[UIImage imageNamed:@"login_bg.png"];
    self.view.layer.contents=(id)imageBg.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}


-(void)updateApp{

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"https://raw.githubusercontent.com/tangyanbin0951/nf_app/master/app.plist"]];
    if (dict) {
        NSArray *list = [dict objectForKey:@"items"];
        NSDictionary *dict2 = [list objectAtIndex:0];
        NSDictionary *dict3 = [dict2 objectForKey:@"metadata"];
        NSString *newVersion = [dict3 objectForKey:@"bundle-version"];
        NSLog(@"新版本%@",newVersion);
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"%@",myVersion);
        
        if (![newVersion isEqualToString:myVersion]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有新版本" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:@"暂不更新", nil];
            [alert show];
        }
    }
}


    //提示框代理
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        NSLog(@"更新");
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://raw.githubusercontent.com/tangyanbin0951/nf_app/master/app.plist"]];
    } else if(buttonIndex == 1){
        NSLog(@"不更新");
    }else{
    
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是最新版" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    
        //隐藏导航条
    [self.navigationController setNavigationBarHidden:YES];
    
    
    NSData *data=[userDefaultes objectForKey:@"loginInfo"];
        //从NSData对象中恢复EVECTION_LOGIN
    HMG_LOGIN *info=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
        //记住账号时，界面显示账号密码
    if ([@"1" isEqualToString:[userDefaultes objectForKey:@"remember_state"]]) {
        
        self.rememberPassword.on=YES;
        
            //保存账号密码
        [self.loginId setText:info.IN_LOGIN_ID];
        [self.password setText:info.IN_LOGIN_PW];
    }
    else
        {
        [self.loginId setText:info.IN_LOGIN_ID];
        [self.password setText:@""];
        self.rememberPassword.on=NO;
        }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(void) AA
{
    
    
}

- (IBAction)loginHandle:(id)sender {
    
    if([@"" isEqualToString:self.loginId.text]||[@"" isEqualToString:self.password.text])
        {
        [HUDManager showMessage:@"账号和密码必须填写" duration:1];
        }
    else
        {
        Common *common=[[Common alloc] initWithView:self.view];
        
        if (common.isConnectionAvailable) {
            HMG_LOGIN *loginParam=[[HMG_LOGIN alloc] init];
            [loginParam setIN_LOGIN_ID:self.loginId.text];
            [loginParam setIN_LOGIN_PW:self.password.text];
            NSString *paramXML=[SoapHelper objToDefaultSoapMessage:loginParam];
            NSLog(@"%@",loginParam);
            NSLog(@"%@",paramXML);
            [serviceHelper asynServiceMethod1:@"HMG_LOGIN" soapMessage:paramXML];
            
        }
        }
}




    //请求失败，返回错误信息
-(void)finishFailedRequest:(NSData *)error
{
    NSLog(@"%@",[[NSString alloc]initWithData:error encoding:NSUTF8StringEncoding]);
    
}

    //请求成功
-(void) finishSuccessRequest:(NSData *)xml
{
    UserInfo *info=[[UserInfo alloc] init];
    NSMutableArray *array =[[NSMutableArray alloc] init];
    [array addObjectsFromArray:[info searchNodeToArray:xml nodeName:@"NewDataSet"]];
    NSLog(@"%@",info);
    
    if ([info.OUT_RESULT isEqualToString:@"0"]) {
        
            //保存用户信息
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        delegate.userInfo=[[UserInfo alloc] init];
        
        [delegate.userInfo setEMP_NO:[info EMP_NO]];
        [delegate.userInfo setEMP_NM:[info EMP_NM]];
        [delegate.userInfo setEMP_TYPE:[info EMP_TYPE]];
        [delegate.userInfo setDEPT_CD:[info DEPT_CD]];
        [delegate.userInfo setDEPT_NM:[info DEPT_NM]];
        [delegate.userInfo setV_MONTH:[info V_MONTH]];
            //登录成功，跳转到主界面
        [HUDManager showMessage:@"登陆成功" duration:1 complection:^{
            
            if(self.rememberPassword.on)
                {
                HMG_LOGIN *info=[[HMG_LOGIN alloc] init];
                [info setIN_LOGIN_ID:self.loginId.text];
                [info setIN_LOGIN_PW:self.password.text];
                
                    //自定义对象归档
                NSData *data=[NSKeyedArchiver archivedDataWithRootObject:info];
                
                [userDefaultes setObject:@"1" forKey:@"remember_state"];
                [userDefaultes setObject:data forKey:@"loginInfo"];
                }
            else
                {
                [userDefaultes removeObjectForKey:@"remember_state"];
                }
            
            [self performSegueWithIdentifier:@"mainMenuId" sender:self];
        }];
    }
    else
        {
            //NSString *str=info.OUT_RESULT_NM;
        [HUDManager showMessage:@"账号或密码错误" duration:1];
        }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
