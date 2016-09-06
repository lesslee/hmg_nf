//
//  ReportUserViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/2/29.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ReportUserViewController.h"
#import "ReportUser.h"
#import "ReportUserCell.h"
#import "ASINetworkQueue.h"
#import "HMG_REPORT_USER.h"
#import <UIKit/UIKit.h>
#import "Common.h"
#import "SoapHelper.h"
ASIHTTPRequest *request;
@interface ReportUserViewController ()

//近30天一线拜访集合
@property (nonatomic ,strong) NSMutableArray  *reportUserArray;

@end

@implementation ReportUserViewController
UITableView *tableView;
//bool canBack=YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.reportUserArray = [[NSMutableArray alloc]init];
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 65)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;

    [self.serviceHelper startQueue];
     [self Reportuser];
}
-(void) Reportuser
{
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        HMG_REPORT_USER *param=[[HMG_REPORT_USER alloc] init];
        
        param.IN_USER_ID = self.reportuser;
        NSLog(@"%@,%@",param.IN_USER_ID , self.reportuser);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        [self.serviceHelper resetQueue];
        request=[ServiceHelper commonSharedRequestMethod:@"HMG_REPORT_USER" soapMessage:paramXml];
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_REPORT_USER",@"name", nil]];
        [self.serviceHelper addRequestQueue:request];
        [self.serviceHelper startQueue];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.serviceHelper) {
        self.serviceHelper = [[ServiceHelper alloc]initWithDelegate:self];
    }
    [self.navigationItem setTitle:@"近30天一线拜访情况"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}


#pragma UITableView代理

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reportUserArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportUserCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportUserCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ReportUserCell" bundle:nil] forCellReuseIdentifier:@"ReportUserCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReportUserCell"];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    }
    
    cell.layer.masksToBounds=YES;

    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportUserCell *tempCell=(ReportUserCell *)cell;
    ReportUser *reportUserModel=(ReportUser*)[self.reportUserArray objectAtIndex:indexPath.row];
    
    tempCell.company.text = reportUserModel.CUSTOM_NM;
    tempCell.number.text = [reportUserModel.CNT stringByAppendingString:@"次"];
    
    NSLog(@"%@,%@",reportUserModel.CUSTOM_NM,reportUserModel.CNT);
}

-(void) goBack
{
    [request clearDelegatesAndCancel];
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    //[HUDManager hide];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}

//请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    
    if ([@"HMG_REPORT_USER" isEqualToString:[dic objectForKey:@"name"]]) {
        
        ReportUser *tempNotify=[[ReportUser alloc] init];
        [self.reportUserArray addObjectsFromArray:[tempNotify searchNodeToArray:xml nodeName:@"NewDataSet"]];
        [tableView reloadData];
        
        [HUDManager hide];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
