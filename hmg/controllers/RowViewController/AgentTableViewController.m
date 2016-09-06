//
//  AgentTableViewController.m
//  hmg
//
//  Created by Lee on 15/3/27.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "AgentTableViewController.h"
#import "UIView+XLFormAdditions.h"
#import "Agent.h"
#import "Agent+Additions.h"
#import "HMG_NF_AGENT_QUERY.h"
#import "SoapHelper.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Common.h"
#import "AppDelegate.h"
#import "AgentCell.h"
@interface AgentTableViewController ()
{
    int currentPage;
    
    int Max_Count;
    BOOL isRefresh;
}
@property (nonatomic) UIView * mapView;
@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;

@end

@implementation AgentTableViewController

@synthesize rowDescriptor = _rowDescriptor;

static NSString *const kCellIdentifier = @"CellIdentifier";

static int pageSize=50;

//ServiceHelper *serviceHelper;

NSArray *agentArray;

UITableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(UIView *)mapView
{
    if (_mapView) return _mapView;
    _mapView = [[UIView alloc] initWithFrame:self.view.bounds];
    //_mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.backgroundColor=[UIColor whiteColor];
    return _mapView;
}

- (CLLRefreshHeadController *)refreshControll
{
    if (!_refreshControll) {
        _refreshControll = [[CLLRefreshHeadController alloc] initWithScrollView:tableView viewDelegate:self];
    }
    return _refreshControll;
}
#pragma mark-
#pragma mark- CLLRefreshHeadContorllerDelegate
- (CLLRefreshViewLayerType)refreshViewLayerType
{
    return CLLRefreshViewLayerTypeOnScrollViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    [self.view addSubview:self.mapView];
    
    self.title=@"选择经销商";
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50)];
    [topView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    UITextField *searchName=[[UITextField alloc] initWithFrame:CGRectMake(10, 8, 230, 35)];
    searchName.tag=11;
    searchName.placeholder=@"经销商名称搜索";
    searchName.borderStyle = UITextBorderStyleRoundedRect;
    
    
    UIButton *searchButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame=CGRectMake(250, 8, 60, 35);
    [searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [searchButton setTitle:@"查询" forState:UIControlStateNormal];
    [searchButton setUserInteractionEnabled:YES];
    searchButton.backgroundColor=[UIColor whiteColor];
    searchButton.layer.cornerRadius=5;
    searchButton.layer.masksToBounds=YES;
    
    [topView addSubview:searchName];
    [topView addSubview:searchButton];
    
    [self.mapView addSubview:topView];
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 114, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-114)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mapView addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
        //[HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
}

-(void) goBack
{
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellId=@"cellId";
//    
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
//    
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    
//    cell.textLabel.text=((Agent *)[agentArray objectAtIndex:indexPath.row]).AGENT_NM;
    
    
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgentCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AgentCell" bundle:nil] forCellReuseIdentifier:@"AgentCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AgentCell"];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [agentArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    AgentCell *tempCell = (AgentCell *)cell;
    Agent *agentModel =(Agent *)[agentArray objectAtIndex:indexPath.row];
    tempCell.AgentName.text = agentModel.AGENT_NM;
    tempCell.Address.text = agentModel.ADDR;

}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Agent * agent= (Agent *)[agentArray objectAtIndex:indexPath.row];
    
    self.rowDescriptor.value = agent;
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        
        [self.serviceHelper resetQueue];
        self.serviceHelper=nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Helpers


//搜索框，点击搜索按钮
-(void) searchButtonClicked
{
        //[HUDManager showMessage:@"加载中..."];
    
    [self.refreshControll startPullDownRefreshing];
}

#pragma mark 服务器请求结果

-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    
    
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
    //NSLog(@"---------------------------------");
    //NSLog(@"%@",error.localizedFailureReason);
    [HUDManager hide];
}

//请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    /**查询门店**/
    if ([@"HMG_NF_AGENT_QUERY" isEqualToString:[dic objectForKey:@"name"]]) {
        
        Agent *tempAgent=[[Agent alloc] init];
        
        NSMutableArray *mm=[tempAgent searchNodeToArray:xml nodeName:@"NewDataSet"];
        
        if (isRefresh) {
            agentArray=mm;
            [self.refreshControll endPullDownRefreshing];
        }
        else
        {
            agentArray=[agentArray arrayByAddingObjectsFromArray:mm];
            [self.refreshControll endPullUpLoading];
        }
        
        if (agentArray.count>0) {
            Agent *model0=(Agent *)[agentArray objectAtIndex:0];
            Max_Count=[model0.TOTAL_RECORDS intValue];
            NSLog(@"%@",model0.TOTAL_RECORDS);
        }
        
        [tableView reloadData];
        [HUDManager hide];
    }
}


#pragma 刷新控件

- (BOOL)hasRefreshFooterView {
    if (agentArray.count > 0 && agentArray.count < Max_Count) {
        return YES;
    }
    return NO;
}

- (BOOL)keepiOS7NewApiCharacter {
    
    if (!self.navigationController)
        return NO;
    BOOL keeped = [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0;
    return keeped;
}

- (void)beginPullDownRefreshing {
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
            //[HUDManager showMessage:@"加载中..."];
    isRefresh=YES;
    currentPage=1;
    //[self setCanBack:NO];
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
            //[HUDManager showMessage:@"加载中..."];
    isRefresh=NO;
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:3];
    }else{
        
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)endRefresh {
    //[self setCanBack:NO];
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        
        NSString *str=((UITextField *)[self.view viewWithTag:11]).text;
        HMG_NF_AGENT_QUERY *param=[[HMG_NF_AGENT_QUERY alloc] init];
        param.IN_AGENT_ID=@"";
        param.IN_AGENT_NM=str;
        param.IN_CHARGE_ID=appDelegate.userInfo.EMP_NO;
        param.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        param.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod1:@"HMG_NF_AGENT_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_NF_AGENT_QUERY",@"name", nil]];
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
        
        currentPage ++;
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        NSString *str=((UITextField *)[self.view viewWithTag:11]).text;
        HMG_NF_AGENT_QUERY *param=[[HMG_NF_AGENT_QUERY alloc] init];
        param.IN_AGENT_ID=@"";
        param.IN_AGENT_NM=str;
        param.IN_CHARGE_ID=appDelegate.userInfo.EMP_NO;
        param.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        param.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod1:@"HMG_NF_AGENT_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_NF_AGENT_QUERY",@"name", nil]];
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }else{
        
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
    }

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end