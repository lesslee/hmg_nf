//
//  ConsumerViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/15.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ConsumerViewController.h"
#import "HMG_NOTIFY.h"
#import "Notify.h"
#import "SoapHelper.h"
#import "ConsumerViewCell.h"
#import "UIView+XLFormAdditions.h"
#import <UIKit/UIKit.h>
#import "Common.h"
#import "AppDelegate.h"
#import "ASINetworkQueue.h"
#import "ConsumerDetailViewController.h"
ASIHTTPRequest *request1;
@interface ConsumerViewController (){
    
    BOOL isRefresh;
}



@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
//consumer公告集合
@property (nonatomic ,strong) NSMutableArray  *consumerArray;

@property(nonatomic, strong)NSString *emp_nm;
@property(nonatomic, strong)NSString *code_nm;
@property(nonatomic, strong)NSString *msg_id;
@property(nonatomic, strong)NSString *des;
@property(nonatomic, strong)NSString *inp_dtm;
@property(nonatomic, strong)NSString *Title;


@end

@implementation ConsumerViewController

//bool canBack=YES;

UITableView *tableView;


-(CLLRefreshHeadController *) refreshControll{
    if (!_refreshControll) {
        _refreshControll = [[CLLRefreshHeadController alloc]initWithScrollView:tableView viewDelegate:self];
    }
    
    return  _refreshControll;
}

#pragma mark-
#pragma mark- CLLRefreshHeadContorllerDelegate
-(CLLRefreshViewLayerType)refreshViewLayerType{
    return CLLRefreshViewLayerTypeOnScrollViews;
}

-(void) viewDidLoad
{    self.edgesForExtendedLayout = UIRectEdgeNone;
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.consumerArray = [[NSMutableArray alloc]init];
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    [HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.serviceHelper) {
        self.serviceHelper = [[ServiceHelper alloc]initWithDelegate:self];
    }
    [self.navigationItem setTitle:@"consumer公告"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
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
    return self.consumerArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumerViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ConsumerViewCell"];
    if (!cell1)
    {
        [tableView  registerNib:[UINib nibWithNibName:@"ConsumerViewCell" bundle:nil] forCellReuseIdentifier:@"ConsumerViewCell"];
        cell1 = [tableView dequeueReusableCellWithIdentifier:@"ConsumerViewCell"];
    }
    
    if (indexPath.row%2==0) {
        cell1.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cell1.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    }
    
    cell1.layer.masksToBounds=YES;
    
    return cell1;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumerViewCell *CsrCell=(ConsumerViewCell *)cell;
    
    Notify *consumer=(Notify *)[self.consumerArray objectAtIndex:indexPath.row];
    NSLog(@"%@",consumer.TITLE);
    
    _Title = consumer.TITLE;
    CsrCell.title.text = _Title;
    
   _inp_dtm = consumer.INP_DTM;
    CsrCell.date.text = _inp_dtm;
    NSLog(@"%@",_inp_dtm);
    _emp_nm = consumer.EMP_NM;
    _code_nm = consumer.CODE_NM;
    _msg_id = consumer.MSG_ID;
    _des = consumer.DESCRIPTION;
    
}


//保存数据到nsuserdefaults
-(void) saveNSUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_code_nm forKey:@"_code_nm"];
    NSLog(@"%@------------",_code_nm);
    [userDefaults setObject:_emp_nm forKey:@"_emp_nm"];
    [userDefaults setObject:_msg_id forKey:@"_msg_id"];
    [userDefaults setObject:_des forKey:@"_des"];
    [userDefaults setObject:_Title forKey:@"_Title"];
    [userDefaults setObject:_inp_dtm forKey:@"_inp_dtm"];
     NSLog(@"%@5555",_inp_dtm);
    [userDefaults synchronize];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    ConsumerDetailViewController *secondView = [[ConsumerDetailViewController alloc]init];
    [self.navigationController pushViewController:secondView animated:YES];
    [self saveNSUserDefaults];

}

-(void) goBack
{
    [request1 clearDelegatesAndCancel];
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
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
    @try {
        if(self){
            if ([@"HMG_NOTIFY" isEqualToString:[dic objectForKey:@"name"]]) {
                
                Notify *tempNotify=[[Notify alloc] init];
                if (isRefresh) {
                    //[self.consumerArray removeAllObjects];
                    [self.consumerArray addObjectsFromArray:[tempNotify searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullDownRefreshing];
                }else{
                    [self.consumerArray addObjectsFromArray:[tempNotify searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    
                }
                
                //                if (self.notifyArray.count > 0) {
                //                    NotifyModel *model0 = (NotifyModel *)[self.notifyArray objectAtIndex:0];
                //                    Max_Count = [model0.TOTAL_RECORDS intValue];
                //                    NSLog(@"%@",model0.TOTAL_RECORDS);
                
                // }
                [tableView reloadData];
                
                [HUDManager hide];
                
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@%@",[exception name],[exception reason]);
    }
    @finally {
        
    }
}
#pragma 刷新控件

- (void)beginPullDownRefreshing {
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
    [HUDManager showMessage:@"加载中..."];
    isRefresh=YES;
    //currentPage=1;
    
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3];
    }else{
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}
- (void)beginPullUpLoading
{
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
    [HUDManager showMessage:@"加载中..."];
    isRefresh=NO;
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:3];
    }else{
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)endRefresh {
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        HMG_NOTIFY *param=[[HMG_NOTIFY alloc] init];
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_NOTIFY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_NOTIFY",@"name", nil]];
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }else{
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)endLoadMore {
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        
        
        HMG_NOTIFY *param=[[HMG_NOTIFY alloc] init];
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_NOTIFY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_NOTIFY",@"name", nil]];
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
    else{
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
