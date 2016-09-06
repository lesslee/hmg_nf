//
//  ReportCoustomerViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/3/2.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ReportCoustomerViewController.h"
#import "ASINetworkQueue.h"
#import "HMG_REPORT_CUSTOMER.h"
#import <UIKit/UIKit.h>
#import "Common.h"
#import "SoapHelper.h"
#import "ReportCustomerCell.h"
#import "ReportCustomer.h"
ASIHTTPRequest *request;
@interface ReportCoustomerViewController ()
//近30天拜访集合
@property (nonatomic ,strong) NSMutableArray  *reportCustomerArray;

//@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
@end



@implementation ReportCoustomerViewController

UITableView *tableView;
//bool canBack=YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.reportCustomerArray = [[NSMutableArray alloc]init];
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 65)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    //[self.serviceHelper startQueue];
    [self ReportCustomer];
}
-(void) ReportCustomer
{
    Common *common=[[Common alloc] initWithView:self.view];
    if (common.isConnectionAvailable) {
        HMG_REPORT_CUSTOMER *param=[[HMG_REPORT_CUSTOMER alloc] init];
        
        param.IN_CUSTOMER_ID = self.reportcustomer;
        
        param.IN_TYPE = self.type1;
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        [self.serviceHelper resetQueue];
        request=[ServiceHelper commonSharedRequestMethod:@"HMG_REPORT_CUSTOMER" soapMessage:paramXml];
        [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_REPORT_CUSTOMER",@"name", nil]];
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
    [self.navigationItem setTitle:@"近30天拜访情况"];
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

#pragma mark - Table view data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.reportCustomerArray.count;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportCustomerCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCustomerCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ReportCustomerCell" bundle:nil] forCellReuseIdentifier:@"ReportCustomerCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCustomerCell"];
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
    ReportCustomerCell *tempCell=(ReportCustomerCell *)cell;
    ReportCustomer *reportCoustmoerModel=(ReportCustomer*)[self.reportCustomerArray objectAtIndex:indexPath.row];
   
    tempCell.cnt.text = [reportCoustmoerModel.CNT stringByAppendingString:@"次"];

    tempCell.user.text = reportCoustmoerModel.EMP_NM;
    
    NSLog(@"%@",reportCoustmoerModel.USER_ID);
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
    
    if ([@"HMG_REPORT_CUSTOMER" isEqualToString:[dic objectForKey:@"name"]]) {
        
        ReportCustomer *tempCoustomer=[[ReportCustomer alloc] init];
        [self.reportCustomerArray addObjectsFromArray:[tempCoustomer searchNodeToArray:xml nodeName:@"NewDataSet"]];
        [tableView reloadData];
        
        [HUDManager hide];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
