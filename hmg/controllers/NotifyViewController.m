//
//  NotifyViewController.m
//  hmg
//
//  Created by Lee on 15/6/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "NotifyViewController.h"
#import "HMG_BOARD_DETAIL.h"
#import "notifyDetailModel.h"
#import "NotifyModel.h"
#import "SoapHelper.h"
#import "HMG_BOARD.h"
#import "NotifyCell.h"
#import "UIView+XLFormAdditions.h"
#import <UIKit/UIKit.h>
#import "Common.h"
#import "AppDelegate.h"
#import "ASINetworkQueue.h"
#import "notifyViewDetailController.h"
ASIHTTPRequest *request1;

static int pageSize=50;
@interface NotifyViewController (){
    
    int currentPage;
    int Max_Count;
    BOOL isRefresh;
    
}

@property(nonatomic, retain) NSString *boardID;
@property(nonatomic ,strong) NSString *seq;
@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
//公告集合
@property (nonatomic ,strong) NSMutableArray  *notifyArray;
@property (nonatomic) NSInteger pageSize;
@end

@implementation NotifyViewController

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
    
    self.notifyArray = [[NSMutableArray alloc]init];
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    
        // [HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
   
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.serviceHelper) {
        self.serviceHelper = [[ServiceHelper alloc]initWithDelegate:self];
    }
    [self.navigationItem setTitle:@"HMG公告"];
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
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifyArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotifyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyCell"];
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotifyCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
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
    NotifyCell *tempCell=(NotifyCell *)cell;
    NotifyModel *notifyModel=(NotifyModel*)[self.notifyArray objectAtIndex:indexPath.row];
    
    tempCell.subject.text = notifyModel.SUBJECT;
    tempCell.writedate.text = notifyModel.WRITE_DATE;
    
    NSLog(@"%@",notifyModel.SUBJECT);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotifyModel *value = (NotifyModel*)[self.notifyArray objectAtIndex:indexPath.row];
   
    self.boardID = value.BOARD_ID;
    self.seq = value.SEQ;
    
    [self performSegueWithIdentifier:@"boardDetailId" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (isRefresh) {
        [self.refreshControll endPullDownRefreshing];
    }else
    {
        
        [self.refreshControll endPullUpLoading];
    }
    
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"boardDetailId"]) {
        notifyViewDetailController *receive = segue.destinationViewController;
        receive.boardId = self.boardID;
        receive.seq = self.seq;
    }
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
    
}

//请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    @try {
        if(self){
            if ([@"HMG_BOARD" isEqualToString:[dic objectForKey:@"name"]]) {
                
                NotifyModel *tempNotify=[[NotifyModel alloc] init];
                if (isRefresh) {
                    //[self.notifyArray removeAllObjects];
                    [self.notifyArray addObjectsFromArray:[tempNotify searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullDownRefreshing];
                }else{
                    [self.notifyArray addObjectsFromArray:[tempNotify searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullUpLoading];
                }
                
                if (self.notifyArray.count > 0) {
                    NotifyModel *model0 = (NotifyModel *)[self.notifyArray objectAtIndex:0];
                    Max_Count = [model0.TOTAL_RECORDS intValue];
                    NSLog(@"%@",model0.TOTAL_RECORDS);
                    
                }
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

- (BOOL)hasRefreshFooterView {
    if (self.notifyArray.count > 0 && self.notifyArray.count < Max_Count) {
        //NSLog(@"%d",Max_Count);
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
//    Common *common=[[Common alloc] initWithView:self.view];
//    
//    if (common.isConnectionAvailable) {
//[HUDManager showMessage:@"加载中..."];
    isRefresh=YES;
    currentPage=1;
    
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3];
//    }else{
//    
//        [HUDManager hide];
//        [self.navigationController popViewControllerAnimated:YES];
//    
//    }
}
- (void)beginPullUpLoading
{
//    Common *common=[[Common alloc] initWithView:self.view];
//    
//    if (common.isConnectionAvailable) {
//[HUDManager showMessage:@"加载中..."];
    isRefresh=NO;
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:3];
//    }else{
//        
//        [HUDManager hide];
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }
}
- (void)endRefresh {
    //[self setCanBack:NO];
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        HMG_BOARD *param=[[HMG_BOARD alloc] init];
        
        param.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        param.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_BOARD" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_BOARD",@"name", nil]];
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
        
        HMG_BOARD *param=[[HMG_BOARD alloc] init];
        
        param.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        param.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
        
        [self.serviceHelper resetQueue];
        
        ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_BOARD" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_BOARD",@"name", nil]];
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }else{
        
        [HUDManager hide];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
