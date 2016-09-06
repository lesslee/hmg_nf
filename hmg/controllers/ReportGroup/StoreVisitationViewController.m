//
//  StoreVisitationViewController.m
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "StoreVisitationViewController.h"
#import "VisitCell.h"
#import "STORE_VISIT_SUMMARY.h"
#import "SoapHelper.h"
#import "HMG_REPORT_COUNT.h"
#import "DOPDropDownMenu.h"
#import "AreaModel.h"
#import "DeptModel.h"
#import "HMG_AREA_QUERY.h"
#import "HMG_DEPT_QUERY.h"
#import "AppDelegate.h"
#import "ReportDetailDelegate.h"
#import "DateSelector_A.h"
@interface StoreVisitationViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,ReportDetailDelegate>
{
    NSInteger rowIndex;
}
//大区
@property (nonatomic, strong) NSMutableArray *areas;
//部门
@property (nonatomic, strong) NSMutableArray *depts;

@property (nonatomic, strong) AreaModel *selectArea;
@property (nonatomic, strong) DeptModel *selectDept;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;

@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
@end

@implementation StoreVisitationViewController



NSArray *arrayVisit;
UITableView *tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyyMM";
    
    self.startDate=[fmt stringFromDate:[NSDate date]];
    self.endDate=[fmt stringFromDate:[NSDate date]];
    
    rowIndex=-1;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    AreaModel *area=[[AreaModel alloc] init];
    area.DEPT_ID=@"0";
    area.DEPT_NM=@"大区";
    
    DeptModel *dept=[[DeptModel alloc] init];
    dept.DEPT_ID=@"0";
    dept.DEPT_NM=@"地区";
    
    self.areas = [NSMutableArray arrayWithObjects:area, nil];
    
    self.depts = [NSMutableArray arrayWithObjects:dept, nil];
    
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.tag=1111;
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 110,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-110)];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource=self;
    tableView.delegate=self;
    
    [self areaQuery];
    
    
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"门店拜访汇总"];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonHandle)];
    
    [self.navigationController setNavigationBarHidden:NO];
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

//后退
-(void) goBack
{
    [self.serviceHelper resetQueue];
    self.serviceHelper=nil;
    [HUDManager hide];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayVisit.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitCell";
    VisitCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotifyCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:2];
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
    VisitCell *tempCell=(VisitCell*)cell;
    STORE_VISIT_SUMMARY *model=(STORE_VISIT_SUMMARY*)[arrayVisit objectAtIndex:indexPath.row];
    tempCell.area.text=model.AREA_NM;
    tempCell.dept.text=model.DEPT_NM;
    tempCell.emp_nm.text=model.EMP_NM;
    tempCell.kf.text=model.KF;
    tempCell.jd.text=model.JD;
    tempCell.hd.text=model.HD;
    tempCell.px.text=model.PX;
    tempCell.clgs.text=model.CLGS;
    tempCell.rc.text=model.RC;
    tempCell.hy.text=model.HY;
    tempCell.dybf.text=model.DYBF;
}


//菜单包含几列
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

//菜单行数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    
    if (column == 0) {
        return self.areas.count;
    }else
    {
        return self.depts.count;
    }
}

//菜单行标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        
        AreaModel *m1=(AreaModel *)self.areas[indexPath.row];
        return m1.DEPT_NM;
        
    } else
    {
        
        DeptModel *m2=(DeptModel *)self.depts[indexPath.row];
        return m2.DEPT_NM;
        
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
            
            ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_DEPT_QUERY" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_DEPT_QUERY",@"name", nil]];
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
            
            self.selectArea=tempArea;
            
                    }
        else
        {
            
            
        }
        [self.depts removeAllObjects];
        DeptModel *dept=[[DeptModel alloc] init];
        dept.DEPT_ID=@"0";
        dept.DEPT_NM=@"部门";
        self.depts = [NSMutableArray arrayWithObjects:dept, nil];
        
        self.selectDept=dept;
    }
    if (indexPath.column==1) {
        
        DeptModel *dept=(DeptModel *)[self.depts objectAtIndex:indexPath.row];
        self.selectDept=dept;
    }
    
    rowIndex=indexPath.row;
    if (indexPath.row!=0) {
        [HUDManager showMessage:@"加载中..."];
        [self.refreshControll startPullDownRefreshing];
    }
    
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
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

//请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    /**查询门店**/
    if ([@"HMG_REPORT_COUNT" isEqualToString:[dic objectForKey:@"name"]]) {
        STORE_VISIT_SUMMARY *model=[[STORE_VISIT_SUMMARY alloc] init];
        arrayVisit=[model searchNodeToArray:xml nodeName:@"NewDataSet"];
        
        [tableView reloadData];
        [self.refreshControll endPullDownRefreshing];
        [HUDManager hide];
    }
    
    /**查询大区**/
    if ([@"HMG_AREA_QUERY" isEqualToString:[dic objectForKey:@"name"]]) {
        AreaModel *tempArea=[[AreaModel alloc] init];
        [self.areas addObjectsFromArray:[tempArea searchNodeToArray:xml nodeName:@"NewDataSet"]];
        self.selectArea=[self.areas objectAtIndex:1];
        
        [HUDManager showMessage:@"加载中..."];
        [self.refreshControll startPullDownRefreshing];
    }
    /**查询部门**/
    if ([@"HMG_DEPT_QUERY" isEqualToString:[dic objectForKey:@"name"]])
    {
        [self.depts removeAllObjects];
        DeptModel *dept=[[DeptModel alloc] init];
        dept.DEPT_ID=@"0";
        dept.DEPT_NM=@"部门";
        self.depts = [NSMutableArray arrayWithObjects:dept, nil];
        
        self.selectDept=dept;
        
        DeptModel *tempDept=[[DeptModel alloc] init];
        [self.depts addObjectsFromArray:[tempDept searchNodeToArray:xml nodeName:@"NewDataSet"]];
        
        //self.selectDept=[self.depts objectAtIndex:1];
    }
    
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
    
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_AREA_QUERY" soapMessage:paramXml];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_AREA_QUERY",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    
    [self.serviceHelper startQueue];
}


-(void) loadVisitInfo
{
    arrayVisit=nil;
    
    HMG_REPORT_COUNT *param=[[HMG_REPORT_COUNT alloc] init];
    param.IN_AREA_ID=self.selectArea.DEPT_ID;
    param.IN_DEPT_CD=self.selectDept.DEPT_ID;
    param.IN_S_MONTH=self.startDate;
    param.IN_E_MONTH=self.endDate;
    
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
    
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_REPORT_COUNT" soapMessage:paramXml ];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_REPORT_COUNT",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    [self.serviceHelper startQueue];
}

//delegate 接收查询日期
-(void) getSTART_DATE:(NSString *)START_DATE andEND_DATE:(NSString *)END_DATE
{
    self.startDate=START_DATE;
    self.endDate=END_DATE;
    
    [HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
}

#pragma 刷新控件

- (BOOL)hasRefreshFooterView {
    return NO;
}

- (BOOL)keepiOS7NewApiCharacter {
    
    if (!self.navigationController)
        return NO;
    BOOL keeped = [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0;
    return keeped;
}

- (void)beginPullDownRefreshing {
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3];
}
- (void)beginPullUpLoading
{
    
    
}

- (void)endRefresh {
    //[self setCanBack:NO];
    [self loadVisitInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
