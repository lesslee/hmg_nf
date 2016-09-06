//
//  WeekendViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/14.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "WeekendViewController.h"
#import "StoreTableViewController.h"
#import "Brand1TableViewController.h"
#import "DOPDropDownMenu.h"
#import "HMG_AREA_QUERY.h"
#import "HMG_DEPT_QUERY.h"
#import "HMG_USER_QUERY.h"
#import "HMG_NF_STORE_QUERY.h"
#import "HMG_WEEKEND_PROMOTION_QUERY.h"
#import "AppDelegate.h"
#import "SoapHelper.h"
#import "ServiceHelper.h"
#import "DeptModel.h"
#import "UserModel.h"
#import "AreaModel.h"
#import "Brand1.h"
#import "Store.h"
#import "WeekendViewCell.h"
#import "weekend.h"
#import "weekendDelegate.h"
#import "SearchViewController.h"
#import "Common.h"
#import "ASINetworkQueue.h"
#import "DateSelector_D.h"
ASIHTTPRequest *request1;

const int pageSize1=50;

@interface WeekendViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,weekendDelegate>
{
    int currentPage;
    int Max_Count;
    BOOL isRefresh;
    
}

@property(nonatomic, retain) NSString * weekendID;
@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;


//大区
@property (nonatomic, strong) NSMutableArray *areas;
//部门
@property (nonatomic, strong) NSMutableArray *depts;
//人员
@property (nonatomic, strong) NSMutableArray *users;

//周末促集合
@property (nonatomic, strong) NSMutableArray *weekends;

#pragma 周末促查询参数
@property (nonatomic, strong) AreaModel *selectArea;
@property (nonatomic, strong) DeptModel *selectDept;
@property (nonatomic, strong) UserModel *selectUser;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) Store *sotre;
@property (nonatomic, strong) Brand1 *brand;
@property (nonatomic) NSInteger pageSize1;

@property(nonatomic, strong)NSString *StoreID;

@end

@implementation WeekendViewController

NSInteger lastColumn1=-1;
NSInteger lastRow1=-1;

//bool canBack=YES;
UITableView *tableView1;
- (CLLRefreshHeadController *)refreshControll
{
    if (!_refreshControll) {
        _refreshControll = [[CLLRefreshHeadController alloc] initWithScrollView:tableView1 viewDelegate:self];
    }
    return _refreshControll;
}

#pragma mark- CLLRefreshHeadContorllerDelegate
- (CLLRefreshViewLayerType)refreshViewLayerType
{
    return CLLRefreshViewLayerTypeOnScrollViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.weekends = [[NSMutableArray alloc] init];
    
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 108,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 105)];
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView1];
    
    tableView1.dataSource=self;
    tableView1.delegate=self;
    
    AreaModel *area=[[AreaModel alloc] init];
    area.DEPT_ID=@"";
    area.DEPT_NM=@"大区";
    
    DeptModel *dept=[[DeptModel alloc] init];
    dept.DEPT_ID=@"";
    dept.DEPT_NM=@"部门";
    
    UserModel *user=[[UserModel alloc] init];
    user.PERNR=@"";
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
    

    NSTimeInterval secondsPerDay1 = 24*60*60*7;
    NSDate *now = [NSDate date];
    NSDate *lastWeek = [now dateByAddingTimeInterval:-secondsPerDay1];
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyyMMdd";
    self.startDate=[fmt stringFromDate:lastWeek];
    self.endDate=[fmt stringFromDate:[NSDate date]];
    
    [self areaQuery];
    
    
    [HUDManager showMessage:@"加载中..."];
    
    [self.refreshControll startPullDownRefreshing];
    
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
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:areaParam];
    
    [self.serviceHelper resetQueue];
    
    request1=[ServiceHelper commonSharedRequestMethod:@"HMG_AREA_QUERY" soapMessage:paramXml];
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
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
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
                AreaModel *tempArea=[[AreaModel alloc] init];
                [self.areas addObjectsFromArray:[tempArea searchNodeToArray:xml nodeName:@"NewDataSet"]];
                
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
            /**查询周末促**/
            if ([@"HMG_WEEKEND_PROMOTION_QUERY" isEqualToString:[dic objectForKey:@"name"]])
            {
                weekend *tempWeekend=[[weekend alloc] init];
                if (isRefresh) {
                    //[self.weekends removeAllObjects];
                    [self.weekends addObjectsFromArray:[tempWeekend searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullDownRefreshing];
                }
                else
                {
                    [self.weekends addObjectsFromArray:[tempWeekend searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullUpLoading];
                }
                
                if (self.weekends.count>0) {
                    weekend *model0=(weekend *)[self.weekends objectAtIndex:0];
                    Max_Count=[model0.TOTAL_RECORDS intValue];
                    NSLog(@"%@",model0.TOTAL_RECORDS);
                }
                
                [tableView1 reloadData];
                [HUDManager hide];
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
            
            if (indexPath.column==lastColumn1) {
                if (indexPath.row==lastRow1) {
                    
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
            
            if (indexPath.column==lastColumn1) {
                if (indexPath.row==lastRow1) {
                    
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
        }
    }
    if (indexPath.column==2) {
        
        UserModel *tempUser=(UserModel *)[self.users objectAtIndex:indexPath.row];
        self.selectUser=tempUser;
    }
    
    lastColumn1=indexPath.column;
    lastRow1=indexPath.row;
}


#pragma UITableView代理

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weekends.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeekendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WeekendViewCell"];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"WeekendViewCell" bundle:nil] forCellReuseIdentifier:@"WeekendViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"WeekendViewCell"];
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
    WeekendViewCell *weekCell=(WeekendViewCell*)cell;
    
    weekend *weekModel=(weekend*)[self.weekends objectAtIndex:indexPath.row];
    
    weekCell.store.text = weekModel.STORE_NM;
    weekCell.prodName.text = weekModel.PROD_NM;
    weekCell.qty.text = weekModel.QTY;
    weekCell.spec.text = weekModel.SPEC;
    weekCell.inpUser.text = weekModel.EMP_NM;
    weekCell.promDtm.text = weekModel.PROM_DTM;
    weekCell.posMoney.text = weekModel.POS_MONEY;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.serviceHelper) {
        
        self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    }
    
    [self.navigationItem setTitle:@"周末促查询"];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"选择日期" style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonHandle)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    DateSelector_D *searchController=[[DateSelector_D alloc] init];
    
    searchController.delegate = self;
    
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

-(void) getSTORE:(Store *) STORE andBRAND:(Brand1 *) BRAND andSTARTDATE:(NSString *) STARTDATE andENDDATE:(NSString *) ENDDATE;
{
    self.startDate=STARTDATE;
    self.endDate=ENDDATE;
    self.sotre = STORE;
    self.brand = BRAND;
    [HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
}



#pragma 刷新控件

- (BOOL)hasRefreshFooterView {
    if (self.weekends.count > 0 && self.weekends.count < Max_Count) {
        
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
    
    [HUDManager showMessage:@"加载中..."];
    isRefresh=YES;
    currentPage=1;
    //[self setCanBack:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3];
}
- (void)beginPullUpLoading
{
    [HUDManager showMessage:@"加载中..."];
    //[self setCanBack:NO];
    isRefresh=NO;
    [self performSelector:@selector(endLoadMore) withObject:nil afterDelay:3];
}

- (void)endRefresh {
    //[self setCanBack:NO];
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        
        HMG_WEEKEND_PROMOTION_QUERY *reportParam=[[HMG_WEEKEND_PROMOTION_QUERY alloc] init];
        if (self.selectArea==nil) {
            reportParam.IN_AREA_ID=@"";
        }
        else
        {
            if ([self.selectArea.DEPT_ID isEqualToString:@"0"]) {
                reportParam.IN_AREA_ID=@"";
            }else
            {
                reportParam.IN_AREA_ID=self.selectArea.DEPT_ID;
            }
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
        if (self.sotre == nil) {
            reportParam.IN_STORE_ID = @"";
        } else {
            reportParam.IN_STORE_ID = self.sotre.STORE_ID;
        }
        
        if (self.brand == nil) {
            reportParam.IN_TYPE_ID = @"";
        } else {
            reportParam.IN_TYPE_ID = self.brand.ID;
        }
        //        reportParam.IN_TYPE_ID = @"";
        //        reportParam.IN_STORE_ID = @"";
        reportParam.IN_START_DATE=self.startDate;
        reportParam.IN_END_DATE=self.endDate;
        reportParam.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        reportParam.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize1] stringValue];
        
        NSLog(@"%@,%@,%@",reportParam.IN_AREA_ID,reportParam.IN_DEPT_ID,reportParam.IN_EMP_NO);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:reportParam];
        NSLog(@"%@",paramXml);
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod:@"HMG_WEEKEND_PROMOTION_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_WEEKEND_PROMOTION_QUERY",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
}
- (void)endLoadMore {
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        currentPage ++;
        HMG_WEEKEND_PROMOTION_QUERY *reportParam=[[HMG_WEEKEND_PROMOTION_QUERY alloc] init];
        if (self.selectArea==nil) {
            reportParam.IN_AREA_ID=@"";
        }
        else
        {
            if ([self.selectArea.DEPT_ID isEqualToString:@"0"]) {
                reportParam.IN_AREA_ID=@"";
            }else
            {
                reportParam.IN_AREA_ID=self.selectArea.DEPT_ID;
            }
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
        
        if (self.sotre == nil) {
            reportParam.IN_STORE_ID = @"";
        } else {
            reportParam.IN_STORE_ID = self.sotre.STORE_ID;
        }
        
        if (self.brand == nil) {
            reportParam.IN_TYPE_ID = @"";
        } else {
            reportParam.IN_TYPE_ID = self.brand.ID;
        }
        // reportParam.IN_TYPE_ID = @"";
        //reportParam.IN_STORE_ID = @"";
        reportParam.IN_START_DATE=self.startDate;
        reportParam.IN_END_DATE=self.endDate;
        reportParam.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        reportParam.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize1] stringValue];
        
        
        NSLog(@"%@,%@,%@",reportParam.IN_AREA_ID,reportParam.IN_DEPT_ID,reportParam.IN_EMP_NO);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:reportParam];
        NSLog(@"%@--------",paramXml);
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod:@"HMG_WEEKEND_PROMOTION_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_WEEKEND_PROMOTION_QUERY",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
    
}

@end

