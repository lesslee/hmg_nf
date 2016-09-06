//
//  StoreLayoutViewController.m
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "StoreLayoutViewController.h"
#import "RankCell.h"
#import "STORE_RANK_SUMMARY.h"
#import "HMG_STORE_DISTRIBUTION.h"
#import "SoapHelper.h"
#import "RankFooterView.h"
#import "RankHeaderView.h"
#import "DOPDropDownMenu.h"
#import "AreaModel.h"
#import "DeptModel.h"
#import "HMG_AREA_QUERY.h"
#import "HMG_DEPT_QUERY.h"
#import "AppDelegate.h"
#import "DateDelegate.h"
#import "DateSelector_C.h"
@interface StoreLayoutViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,DateDelegate,CLLRefreshHeadControllerDelegate>
{
    NSInteger rowIndex;
}
//大区
@property (nonatomic, strong) NSMutableArray *areas;
//部门
@property (nonatomic, strong) NSMutableArray *depts;


@property (nonatomic, strong) AreaModel *selectArea;
@property (nonatomic, strong) DeptModel *selectDept;

@property (nonatomic, strong) NSString *startYear;
@property (nonatomic, strong) NSString *sMonth;
@property (nonatomic, strong) NSString *eMonth;

@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
@end

@implementation StoreLayoutViewController

NSArray *arrayRank;
UITableView *tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyy";
    NSDateFormatter *fmt1=[[NSDateFormatter alloc] init];
    fmt1.dateFormat=@"M";
    
    self.startYear=[fmt stringFromDate:[NSDate date]];
    self.sMonth=[fmt1 stringFromDate:[NSDate date]];
    self.eMonth=[fmt1 stringFromDate:[NSDate date]];
    
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
    
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 107,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-107)];
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource=self;
    tableView.delegate=self;
    
    [self areaQuery];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"地区别门店分布"];
    
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
    
    DateSelector_C *searchController=[[DateSelector_C alloc] init];
    
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

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rank" owner:self options:nil];
    RankHeaderView *headerView=(RankHeaderView *)[nib objectAtIndex:0];
    return headerView;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rank" owner:self options:nil];
    RankFooterView *footerView=(RankFooterView*)[nib objectAtIndex:1];
    footerView.flow.text=[self sumFlow];
    footerView.storeCount.text=[self getStoreCount];
    
    return footerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayRank.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RankCell";
    RankCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rank" owner:self options:nil];
        
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
    RankCell *tempCell=(RankCell*)cell;
    STORE_RANK_SUMMARY *model=(STORE_RANK_SUMMARY*)[arrayRank objectAtIndex:indexPath.row];
    tempCell.city.text=model.CITY;
    tempCell.flow.text=model.CITY_FLOW;
    tempCell.storeCount.text=model.STORE_COUNT;
    tempCell.rank.text=model.ECONOMIC_RANK;
    tempCell.zhanbi.text=model.ZHANBI;
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
        [self loadLayoutInfo];
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
    /**城市经济排名**/
    if ([@"HMG_STORE_DISTRIBUTION" isEqualToString:[dic objectForKey:@"name"]]) {
        STORE_RANK_SUMMARY *model=[[STORE_RANK_SUMMARY alloc] init];
        arrayRank=[model searchNodeToArray:xml nodeName:@"NewDataSet"];
        [self getZhanbi];
        
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
    }
    
}

//门店总数
-(NSString *) getStoreCount
{
    NSInteger count;
    
    for (STORE_RANK_SUMMARY *model in arrayRank) {
        
        count+=[model.STORE_COUNT integerValue];
    }
    
    return [NSString stringWithFormat:@"%d",(int)count];
    
}

//总流向
-(NSString *) sumFlow
{
    float flow;
    for (STORE_RANK_SUMMARY *model in arrayRank) {
        
        flow+=[model.CITY_FLOW floatValue];
    }
    
    return [NSString stringWithFormat:@"%.2f",flow];
}

-(void) getZhanbi
{
    for (STORE_RANK_SUMMARY *model in arrayRank) {
        if ([model.CITY_FLOW isEqualToString:@"0"]) {
            model.ZHANBI=@"0%";
        }else{
            float zhanbi=([model.CITY_FLOW floatValue]/[[self sumFlow] floatValue])*100;
            model.ZHANBI=[NSString stringWithFormat:@"%.2f%%",zhanbi];
        }
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


-(void) loadLayoutInfo
{
    arrayRank=nil;
    
    HMG_STORE_DISTRIBUTION *param=[[HMG_STORE_DISTRIBUTION alloc] init];
    param.IN_AREA_ID=self.selectArea.DEPT_ID;
    param.IN_DEPT_CD=self.selectDept.DEPT_ID;
    param.IN_S_YEAR=self.startYear;
    param.IN_S_MONTH=self.sMonth;
    param.IN_E_MONTH=self.eMonth;
    
    
       NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
    
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_STORE_DISTRIBUTION" soapMessage:paramXml ];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_STORE_DISTRIBUTION",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    [self.serviceHelper startQueue];
}

-(void) getYEAR:(NSString *)year andSMonth:(NSString *)sMonth andEMonth:(NSString *)eMonth
{
    self.startYear=year;
    self.sMonth=sMonth;
    self.eMonth=eMonth;
    
    [self loadLayoutInfo];
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
    [self loadLayoutInfo];
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
