//
//  QueryReportViewController.m
//  hmg
//
//  Created by Lee on 15/3/26.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "QueryReportViewController.h"
#import "DOPDropDownMenu.h"
#import "HMG_AREA_QUERY.h"
#import "HMG_DEPT_QUERY.h"
#import "HMG_USER_QUERY.h"
#import "HMG_DAILY_REPORT_QUERY.h"
#import "AppDelegate.h"
#import "SoapHelper.h"
#import "ServiceHelper.h"
#import "DeptModel.h"
#import "UserModel.h"
#import "AreaModel.h"
#import "ReportCell.h"
#import "ReportModel.h"
#import "ReportDetailDelegate.h"
#import "ReportDetailViewController.h"
#import "ReportDetailDelegate.h"
#import "SearchViewController.h"
#import "Common.h"
#import "ASINetworkQueue.h"
#import "DateSelector_A.h"
#import "ReportUserViewController.h"
#import "ReportUser.h"
#import "UserInfo.h"
#import "HMG_CHECK_IN.h"
#import "AppDelegate.h"
#import "ReportModel.h"
#import "SAVE_DAILY_REPORT.h"
#import "ReportCoustomerViewController.h"
#import "ReportCustomer.h"
#import "HMG_DAILY_REPORT_DETAIL.h"
#import "ReportPhotoViewController.h"

ASIHTTPRequest *request1;

const int pageSize=50;
@interface QueryReportViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,ReportDetailDelegate>
{
    int currentPage;
    int Max_Count;
    BOOL isRefresh;
    NSString *inpdtm;
    NSString *prouctName;
    
    
}

@property(nonatomic, retain) NSString * reportID;
@property (nonatomic,strong)NSString  *reportuser;
@property(nonatomic,strong)NSString *reportcustomer;
@property(nonatomic ,strong)NSString *type1;


//@property(nonatomic, retain) NSObject<ReportDetailDelegate> * reportDelegate;

@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;

//大区
@property (nonatomic, strong) NSMutableArray *areas;
//部门
@property (nonatomic, strong) NSMutableArray *depts;
//人员
@property (nonatomic, strong) NSMutableArray *users;

//日报集合
@property (nonatomic, strong) NSMutableArray *reports;

#pragma 日报查询参数
@property (nonatomic, strong) AreaModel *selectArea;
@property (nonatomic, strong) DeptModel *selectDept;
@property (nonatomic, strong) UserModel *selectUser;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
//@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageSize;

@end

@implementation QueryReportViewController

NSInteger lastColumn=-1;
NSInteger lastRow=-1;


bool canBack=YES;

UITableView *tableView;

//ServiceHelper *serviceHelper;

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
    
    self.reports=[[NSMutableArray alloc] init];
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 105,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-105)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
    
    
    
    AreaModel *area=[[AreaModel alloc] init];
    
    area.DEPT_ID=@"0";
    area.DEPT_NM=@"大区";
    
    
    DeptModel *dept=[[DeptModel alloc] init];
    dept.DEPT_ID=@"0";
    dept.DEPT_NM=@"部门";
    
    UserModel *user=[[UserModel alloc] init];
    user.PERNR=@"0";
    user.ENAME=@"人员";
    
    self.areas = [NSMutableArray arrayWithObjects:area, nil];
    
    self.depts = [NSMutableArray arrayWithObjects:dept, nil];
    
    self.users = [NSMutableArray arrayWithObjects:user, nil];
    
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.tag=1111;
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    button.frame = CGRectMake(10, 110, self.view.frame.size.width - 20, 40);
    //    [button setUserInteractionEnabled:YES];
    //    button.layer.cornerRadius=5;
    //    button.layer.masksToBounds=YES;
    //
    //    [button setBackgroundImage:[self createImageWithColor:[self colorWithHexString:@"#41b6ca" alpha:(1.0f)]] forState:UIControlStateNormal];
    //
    //        //button.backgroundColor = [UIColor blueColor];
    //    [button setTitle:@"查  询" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:20];
    //    [button addTarget:self action:@selector(search1) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    
    
    NSTimeInterval secondsPerDay1 = 24*60*60*7;
    NSDate *now = [NSDate date];
    NSDate *lastWeek = [now dateByAddingTimeInterval:-secondsPerDay1];
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyyMMdd";
    self.startDate=[fmt stringFromDate:lastWeek];
    self.endDate=[fmt stringFromDate:[NSDate date]];
    [self areaQuery];
    
    
    //[HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
    
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


-(void)search1{
    
    //[HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
    [self.reports removeAllObjects];
    [tableView reloadData];
}



-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

//加载大区
-(void) areaQuery
{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    
    HMG_AREA_QUERY *areaParam=[[HMG_AREA_QUERY alloc] init];
    [areaParam setIN_DEPT_ID:appDelegate.userInfo.DEPT_CD];
    [areaParam setIN_IS_FCU:appDelegate.userInfo.EMP_TYPE];
    
    NSLog(@"%@",areaParam.IN_IS_FCU);
    
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:areaParam];
    
    [self.serviceHelper resetQueue];
    
    request1=[ServiceHelper commonSharedRequestMethod1:@"HMG_AREA_QUERY" soapMessage:paramXml];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_AREA_QUERY",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    
    [self.serviceHelper startQueue];
}

#pragma 请求服务器结果

-(void) finishQueueComplete
{
    
}



-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    //[HUDManager showErrorWithMessage:@"网络错误" duration:1];
    //NSLog(@"---------------------------------");
    //NSLog(@"%@",error.localizedFailureReason);
    
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    
}

//请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    @try {
        if(self)
        {
            /**查询大区**/
            if ([@"HMG_AREA_QUERY" isEqualToString:[dic objectForKey:@"name"]]) {
                AppDelegate *del = [UIApplication sharedApplication].delegate;
                AreaModel *tempArea=[[AreaModel alloc] init];
                [self.areas removeAllObjects];
                [self.areas addObjectsFromArray:[tempArea searchNodeToArray:xml nodeName:@"NewDataSet"]];
                if ([del.userInfo.EMP_TYPE isEqualToString:@"0"]) {
                    self.selectArea=(AreaModel*)[self.areas objectAtIndex:0];
                    NSLog(@"%@123",[self.areas[0]DEPT_NM]);
                }else{
                    self.selectArea.DEPT_ID = @"";
                    
                }
                
            }
            /**查询部门**/
            if ([@"HMG_DEPT_QUERY" isEqualToString:[dic objectForKey:@"name"]])
            {
                DeptModel *tempDept=[[DeptModel alloc] init];
                [self.depts addObjectsFromArray:[tempDept searchNodeToArray:xml nodeName:@"NewDataSet"]];
            }
            /**查询人员**/
            if ([@"HMG_USER_QUERY" isEqualToString:[dic objectForKey:@"name"]])
            {
                UserModel *tempUser=[[UserModel alloc] init];
                [self.users addObjectsFromArray:[tempUser searchNodeToArray:xml nodeName:@"NewDataSet"]];
            }
            /**查询日报**/
            if ([@"HMG_DAILY_REPORT_QUERY" isEqualToString:[dic objectForKey:@"name"]])
            {
                ReportModel *tempReport=[[ReportModel alloc] init];
                if (isRefresh) {
                    
                    
                    [self.reports removeAllObjects];
                    
                    [self.reports addObjectsFromArray:[tempReport searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    
                    [self.refreshControll endPullDownRefreshing];
                    
                    
                }
                else
                {
                    
                    [self.reports addObjectsFromArray:[tempReport searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullUpLoading];
                    
                }
                
                if (self.reports.count>0) {
                    ReportModel *model0=(ReportModel *)[self.reports objectAtIndex:0];
                    Max_Count=[model0.TOTAL_RECORDS intValue];
                    NSLog(@"%@",model0.TOTAL_RECORDS);
                }else{
                    
                    [self.reports removeAllObjects];
                    //[tableView reloadData];
                }
                
                [tableView reloadData];
                //[HUDManager hide];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@%@",[exception name],[exception reason]);
    }
    @finally {
        
    }
}


#pragma 顶部下拉菜单

////筛选条件导航
//-(void) searchButtonHandle
//{
//    [self.serviceHelper resetQueue];
//    self.serviceHelper=nil;
//    [self performSegueWithIdentifier:@"searchId" sender:self];
//}

//菜单包含几列
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

//菜单行数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    
    if (column == 0) {
        return self.areas.count;
        
    }else if (column == 1){
        return self.depts.count;
    }
    else
    {
        return self.users.count;
    }
}


//菜单行标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        
        AreaModel *m1=(AreaModel *)self.areas[indexPath.row];
        
        return m1.DEPT_NM;
        
        
    } else if (indexPath.column == 1){
        DeptModel *m2=(DeptModel *)self.depts[indexPath.row];
        return m2.DEPT_NM;
        
    } else{
        
        UserModel *m3=(UserModel *)self.users[indexPath.row];
        return m3.ENAME;
    }
    
}


//DropView  菜单点击
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    if (indexPath.column==0) {
        AreaModel *tempArea=(AreaModel *)[self.areas objectAtIndex:indexPath.row];
        
        if (![tempArea.DEPT_ID isEqualToString:@"0"]) {
            
            HMG_DEPT_QUERY *deptParam=[[HMG_DEPT_QUERY alloc] init];
            [deptParam setIN_DEPT_ID:tempArea.DEPT_ID];
            
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:deptParam];
            
            [self.serviceHelper resetQueue];
            
            request1=[ServiceHelper commonSharedRequestMethod:@"HMG_DEPT_QUERY" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_DEPT_QUERY",@"name", nil]];
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
            
            self.selectArea=tempArea;
            
            if (indexPath.column==lastColumn) {
                if (indexPath.row==lastRow) {
                    
                }
                else
                {
                    [self.depts removeAllObjects];
                    DeptModel *dept=[[DeptModel alloc] init];
                    dept.DEPT_ID=@"0";
                    dept.DEPT_NM=@"部门";
                    self.depts = [NSMutableArray arrayWithObjects:dept, nil];
                    
                    
                    [self.users removeAllObjects];
                    UserModel *user=[[UserModel alloc] init];
                    user.PERNR=@"0";
                    user.ENAME=@"人员";
                    self.users = [NSMutableArray arrayWithObjects:user, nil];
                    
                    
                    self.selectDept=dept;
                    
                    self.selectUser=user;
                }
            }
        }
        else
        {
            [self.depts removeAllObjects];
            DeptModel *dept=[[DeptModel alloc] init];
            dept.DEPT_ID=@"0";
            dept.DEPT_NM=@"部门";
            self.depts = [NSMutableArray arrayWithObjects:dept, nil];
            
            
            [self.users removeAllObjects];
            UserModel *user=[[UserModel alloc] init];
            user.PERNR=@"0";
            user.ENAME=@"人员";
            self.users = [NSMutableArray arrayWithObjects:user, nil];
        }
    }
    if (indexPath.column==1) {
        DeptModel *tempDept=(DeptModel *)[self.depts objectAtIndex:indexPath.row];
        
        if (![tempDept.DEPT_ID isEqualToString:@"0"]) {
            HMG_USER_QUERY *userParam=[[HMG_USER_QUERY alloc] init];
            [userParam setIN_DEPT_ID:tempDept.DEPT_ID];
            
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:userParam];
            
            [self.serviceHelper resetQueue];
            
            request1=[ServiceHelper commonSharedRequestMethod:@"HMG_USER_QUERY" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_USER_QUERY",@"name", nil]];
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
            
            self.selectDept=tempDept;
            
            if (indexPath.column==lastColumn) {
                if (indexPath.row==lastRow) {
                    
                }
                else
                {
                    [self.users removeAllObjects];
                    UserModel *user=[[UserModel alloc] init];
                    user.PERNR=@"0";
                    user.ENAME=@"人员";
                    self.users = [NSMutableArray arrayWithObjects:user, nil];
                    
                    self.selectUser=user;
                }
            }
        }else
        {
            [self.users removeAllObjects];
            UserModel *user=[[UserModel alloc] init];
            user.PERNR=@"0";
            user.ENAME=@"人员";
            self.users = [NSMutableArray arrayWithObjects:user, nil];
            
            self.selectDept=tempDept;
            
        }
    }
    if (indexPath.column==2) {
        
        UserModel *tempUser=(UserModel *)[self.users objectAtIndex:indexPath.row];
        self.selectUser=tempUser;
    }
    
    lastColumn=indexPath.column;
    lastRow=indexPath.row;
    
    
    //    if (indexPath.row!=0) {
    //            //[HUDManager showMessage:@"加载中..."];
    //        [self.refreshControll startPullDownRefreshing];
    //
    //    }
    
}


#pragma UITableView代理

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reports.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReportCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
    ReportModel *tempReport=[[ReportModel alloc] init];
    
    if (!cell)
    {
        if ([tempReport.TOTAL_RECORDS isEqualToString:@"0"]) {
            //[self.reports removeObjectAtIndex:0];
            //[self.reports removeObjectAtIndex:1];
            cell.userInteractionEnabled = NO;
        } else {
            
            [tableView registerNib:[UINib nibWithNibName:@"ReportCell" bundle:nil] forCellReuseIdentifier:@"ReportCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell"];
        }
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

//-------------------------------
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath!=nil) {
        
        
        ReportCell *tempCell=(ReportCell*)cell;
        
        ReportModel *reportModel=(ReportModel*)[self.reports objectAtIndex:indexPath.row];
        if ([reportModel.STORE_NM isEqualToString:@"无"]) {
            
            [tempCell.company setTitle: reportModel.AGENT_NM forState:UIControlStateNormal];
        }else
        {
            [tempCell.company setTitle:reportModel.STORE_NM forState:UIControlStateNormal];
        }
        //    inpdtm =  reportModel.INP_DTM;
        //    tempCell.date.text = inpdtm;
        tempCell.date.text = reportModel.INP_DTM;
        tempCell.rmk.text=reportModel.RMK;
        tempCell.product.text=reportModel.PRODUCT_NM;
        tempCell.purpose.text=reportModel.VISIT_PURPOSE;
        [tempCell.ename setTitle:reportModel.EMP_NM forState:UIControlStateNormal];
        
        [tempCell.ename addTarget:self action:@selector(reportUser:) forControlEvents:UIControlEventTouchUpInside];
        tempCell.ename.tag = indexPath.row ;
        [tempCell.company addTarget:self action:@selector(reportCoustomer:) forControlEvents:UIControlEventTouchUpInside];
        tempCell.company.tag = indexPath.row ;
    }
}
//-(void) saveNSUserDefaults{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:inpdtm forKey:@"inpdtm"];
//    NSLog(@"%@1-3",inpdtm);
//    [userDefaults synchronize];
//}

-(void)reportUser:(UIButton *)sender{
    
    long row = (long)sender.tag ;
    NSLog(@"%ld",row);
    ReportModel *reportModel=(ReportModel*)[self.reports objectAtIndex:row];
    
    self.reportuser = reportModel.EMP_NO;
    
    NSLog(@"%@,%@",self.reportuser,reportModel.EMP_NO);
    [self performSegueWithIdentifier:@"reportuserId" sender:self];
    
}

-(void)reportCoustomer:(UIButton *)sender{
    long row = (long)sender.tag ;
    NSLog(@"%ld",row);
    ReportModel *reportModel=(ReportModel*)[self.reports objectAtIndex:row];
    if ([reportModel.STORE_NM isEqualToString:@"无"]) {
        self.reportcustomer = reportModel.CUSTOMER_ID;
        self.type1 =@"1";
        
    }
    else{
        self.reportcustomer = reportModel.CUSTOMER_ID;
        self.type1 =@"0";
    }
    [self performSegueWithIdentifier:@"ReportCustomerCellId" sender:self];
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (isRefresh) {
        [self.refreshControll endPullDownRefreshing];
    }else
    {
        
        [self.refreshControll endPullUpLoading];
    }
    
    if ([segue.identifier isEqualToString:@"reportDetailId"]) {
        id detailViewController=segue.destinationViewController;
        [detailViewController setValue:self.reportID forKey:@"reportId"];
        [detailViewController setValue:inpdtm forKey:@"inpdtm"];
        
    }
    if ([segue.identifier isEqualToString:@"searchId"]) {
        SearchViewController *searchController=(SearchViewController *)segue.destinationViewController;
        searchController.delegate=self;
    }
    if ([segue.identifier isEqualToString:@"reportuserId"]) {
        id CoustomerViewController = segue.destinationViewController;
        [CoustomerViewController setValue:self.reportuser forKey:@"reportuser"];
        
    }
    if ([segue.identifier isEqualToString:@"ReportCustomerCellId"]) {
        
        ReportCoustomerViewController *vc  = (ReportCoustomerViewController *)segue.destinationViewController;
        vc.reportcustomer = self.reportcustomer;
        vc.type1 = self.type1;
        NSLog(@"%@,%@",vc.reportcustomer,vc.type1);
    }
    
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReportModel *value=(ReportModel*)[self.reports objectAtIndex:indexPath.row];
    self.reportID=value.ID;
    
    inpdtm = value.INP_DTM;
    NSLog(@"%@",inpdtm);
    prouctName = value.PRODUCT_NM;
    NSLog(@"%@=======123",prouctName);
    
    [self performSegueWithIdentifier:@"reportDetailId" sender:self];
}

#pragma 刷新控件

- (BOOL)hasRefreshFooterView {
    if (self.reports.count > 0 && self.reports.count < Max_Count) {
        
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
        
    }
}
- (void)beginPullUpLoading
{
    //[HUDManager showMessage:@"加载中..."];
    //[self setCanBack:NO];
    isRefresh=NO;
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:3];
}

- (void)endRefresh {
    //[self setCanBack:NO];
    
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        
        HMG_DAILY_REPORT_QUERY *reportParam=[[HMG_DAILY_REPORT_QUERY alloc] init];
        if (self.selectArea==nil) {
            reportParam.IN_AREA_ID=@"";
        }
        else
        {
            
            //            if ([self.selectArea.DEPT_ID isEqualToString:@"0"]) {
            //                reportParam.IN_AREA_ID=@"";
            //            }else
            //            {
            reportParam.IN_AREA_ID=self.selectArea.DEPT_ID;
            //}
        }
        if (self.selectDept==nil) {
            reportParam.IN_DEPT_ID=@"";
        }
        else
        {
            if ([self.selectDept.DEPT_ID isEqualToString:@"0"]) {
                reportParam.IN_DEPT_ID=@"";
            }else
            {
                reportParam.IN_DEPT_ID=self.selectDept.DEPT_ID;
            }
        }
        if (self.selectUser==nil) {
            reportParam.IN_EMP_NO=@"";
        }
        else
        {
            if ([self.selectUser.PERNR isEqualToString:@"0"]) {
                reportParam.IN_EMP_NO=@"";
            }else
            {
                reportParam.IN_EMP_NO=self.selectUser.PERNR;
            }
        }
        reportParam.IN_KIND = @"B";
        reportParam.IN_START_DATE=self.startDate;
        
        reportParam.IN_END_DATE=self.endDate;
        reportParam.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        reportParam.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
        NSLog(@"%@,%@,%@,%@,%@",reportParam.IN_AREA_ID,reportParam.IN_DEPT_ID,reportParam.IN_EMP_NO,reportParam.IN_START_DATE,reportParam.IN_END_DATE);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:reportParam];
        NSLog(@"%@",paramXml);
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod1:@"HMG_DAILY_REPORT_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_DAILY_REPORT_QUERY",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
        
        [self.reports removeAllObjects];
        [tableView reloadData];
    }
}
- (void)endLoadMore {
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        currentPage ++;
        HMG_DAILY_REPORT_QUERY *reportParam=[[HMG_DAILY_REPORT_QUERY alloc] init];
        if (self.selectArea==nil) {
            reportParam.IN_AREA_ID=@"";
        }
        else
        {
            //            if ([self.selectArea.DEPT_ID isEqualToString:@"0"]) {
            //                reportParam.IN_AREA_ID=@"";
            //            }else
            //            {
            reportParam.IN_AREA_ID=self.selectArea.DEPT_ID;
            //}
        }
        if (self.selectDept==nil) {
            reportParam.IN_DEPT_ID=@"";
        }
        else
        {
            if ([self.selectDept.DEPT_ID isEqualToString:@"0"]) {
                reportParam.IN_DEPT_ID=@"";
            }else
            {
                reportParam.IN_DEPT_ID=self.selectDept.DEPT_ID;
            }
        }
        if (self.selectUser==nil) {
            reportParam.IN_EMP_NO=@"";
        }
        else
        {
            if ([self.selectUser.PERNR isEqualToString:@"0"]) {
                reportParam.IN_EMP_NO=@"";
            }else
            {
                reportParam.IN_EMP_NO=self.selectUser.PERNR;
            }
        }
        reportParam.IN_KIND = @"B";
        reportParam.IN_START_DATE=self.startDate;
        reportParam.IN_END_DATE=self.endDate;
        reportParam.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        reportParam.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
        
        NSLog(@"%@,%@,%@,%@,%@",reportParam.IN_AREA_ID,reportParam.IN_DEPT_ID,reportParam.IN_EMP_NO,reportParam.IN_START_DATE,reportParam.IN_END_DATE);
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:reportParam];
        //NSLog(@"%@",paramXml);
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod1:@"HMG_DAILY_REPORT_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_DAILY_REPORT_QUERY",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.serviceHelper) {
        
        self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    }
    
    [self.navigationItem setTitle:@"日报查询"];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"筛选日期" style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonHandle)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
    //[self.refreshControll startPullDownRefreshing];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////禁用于开启后退按钮
//-(void) setCanBack:(BOOL) value
//{
//    canBack=value;
//}

//查询
-(void) searchButtonHandle
{
    [self.serviceHelper resetQueue];
    
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.3];
    
    [animation setType: kCATransitionMoveIn];
    
    [animation setSubtype: kCATransitionPush];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    DateSelector_A *searchController=[[DateSelector_A alloc] init];
    
    searchController.delegate=self;
    
    [self.navigationController pushViewController:searchController animated:NO];
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}
//返回
-(void) goBack
{
    [request1 clearDelegatesAndCancel];
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
    [self.navigationController popViewControllerAnimated:YES];
}



//delegate 接收查询日期
-(void) getSTART_DATE:(NSString *)START_DATE andEND_DATE:(NSString *)END_DATE
{
    [self.refreshControll startPullDownRefreshing];
    self.startDate=START_DATE;
    self.endDate=END_DATE;
    
    //[HUDManager showMessage:@"加载中..."];
    
}


@end
