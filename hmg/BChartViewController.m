//
//  BChartViewController.m
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "BChartViewController.h"
#import "SoapHelper.h"
#import "DOPDropDownMenu.h"
#import "AreaModel.h"
#import "DeptModel.h"
#import "HMG_AREA_QUERY.h"
#import "HMG_DEPT_QUERY.h"
#import "AppDelegate.h"
#import "DateSelector_C.h"
#import "UUChart.h"
#import "HMG_STORE_FLOW_BP.h"
#import "StoreFlowBP.h"
@interface BChartViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,DateDelegate,UUChartDataSource>
{
    float x;
    int countMonth;
    int z;
}
//大区
@property (nonatomic, strong) NSMutableArray *areas;
//部门
@property (nonatomic, strong) NSMutableArray *depts;

@property (nonatomic, strong) AreaModel *selectArea;
@property (nonatomic, strong) DeptModel *selectDept;

//地区别流向数据集合
@property(nonatomic,strong)NSMutableArray *storeFlow;
@property(nonatomic, strong) NSMutableArray *ary;

@property (nonatomic, strong) NSString *startYear;
@property (nonatomic, strong) NSString *sMonth;
@property (nonatomic, strong) NSString *eMonth;

@end

@implementation BChartViewController
UUChart *chartView;

UICollectionView *collectionView;


- (void)configUI
{ if (chartView) {
    [chartView removeFromSuperview];
    chartView = nil;
}
    
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.height, 345)
                                              withSource:self
                                               withStyle:UUChartLineStyle];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 480, [UIScreen mainScreen].bounds.size.width, 40)];
    lable.text = @"单位为：万";
    
    [self.view addSubview:lable];
    [chartView showInView:self.view];
    //UIScrollview
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width - 5, 450)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled=YES;
    scrollView.userInteractionEnabled=YES;
    
    [scrollView addSubview:chartView];
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.height , 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
     self.storeFlow = [[NSMutableArray alloc]init];
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    fmt.dateFormat=@"yyyy";
    NSDateFormatter *fmt1=[[NSDateFormatter alloc] init];
    fmt1.dateFormat=@"M";
    
    self.startYear=[fmt stringFromDate:[NSDate date]];
    self.sMonth=[fmt1 stringFromDate:[NSDate date]];
    self.eMonth=[fmt1 stringFromDate:[NSDate date]];
    
    
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    

    AreaModel *area=[[AreaModel alloc] init];
    area.DEPT_ID=@"0";
    area.DEPT_NM=@"大区";
    
    DeptModel *dept=[[DeptModel alloc] init];
    dept.DEPT_ID=@"0";
    dept.DEPT_NM=@"地区";
    
    self.areas = [NSMutableArray arrayWithObjects:area, nil];
    
    self.depts = [NSMutableArray arrayWithObjects:dept, nil];
    
    [self areaQuery];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.tag=1111;
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"地区流向曲线图"];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonHandle)];
    
    [self.navigationController setNavigationBarHidden:NO];
    
//    //隐藏navigationController
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    //隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void) viewDidAppear:(BOOL)animated
{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //显示navigationController
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
    [self.navigationController popViewControllerAnimated:YES];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        }
        else
        {
            
            
        }
        self.selectArea=tempArea;
        
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

#pragma mark 服务器请求结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    if ([@"HMG_AREA_QUERY" isEqualToString:[dic objectForKey:@"name"]]) {
        AreaModel *tempArea=[[AreaModel alloc] init];
        [self.areas addObjectsFromArray:[tempArea searchNodeToArray:xml nodeName:@"NewDataSet"]];
        
        self.selectArea=[self.areas objectAtIndex:1];
    
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
    
    /**查询地区别流**/
    if ([@"HMG_STORE_FLOW_BP" isEqualToString:[dic objectForKey:@"name"]])
    {
        StoreFlowBP *tempReport=[[StoreFlowBP alloc] init];
        
       [self.storeFlow addObjectsFromArray:[tempReport searchNodeToArray:xml nodeName:@"NewDataSet"]];
       
        z = (int) self.storeFlow.count;
        NSLog(@"%d,0000",z);
        
        StoreFlowBP *model1 = (StoreFlowBP *)[self.storeFlow firstObject];
             x = [model1.REPORT_FLOW floatValue];
            NSLog(@"%0.2f",x);
        
        countMonth = [model1.REPORT_MONTH intValue];
            NSLog(@"%d...",countMonth);
        
        [self configUI];
    }
  }


#pragma mark - @required


-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

}
-(void) getYEAR:(NSString *)year andSMonth:(NSString *)sMonth andEMonth:(NSString *)eMonth
{
    self.startYear=year;
    self.sMonth=sMonth;
    self.eMonth=eMonth;
    
    [self loadLayoutInfo];
  
}

-(void) loadLayoutInfo
{
    HMG_STORE_FLOW_BP *param=[[HMG_STORE_FLOW_BP alloc] init];
    param.IN_AREA_ID = self.selectArea.DEPT_ID;
    param.IN_DEPT_CD = self.selectDept.DEPT_ID;
    param.IN_YEAR = self.startYear;
    param.IN_S_MONTH = self.sMonth;
    param.IN_E_MONTH = self.eMonth;
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
    
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_STORE_FLOW_BP" soapMessage:paramXml ];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_STORE_FLOW_BP",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    [self.serviceHelper startQueue];
}

//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i = countMonth ; i < z + countMonth; i++) {
        // NSLog(@"%d-----",countMonth);
        NSString * str = [NSString stringWithFormat:@"%d月",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSMutableArray *ary = [NSMutableArray array];
    for(StoreFlowBP * model in _storeFlow){
        
        float flow = [model.REPORT_FLOW floatValue] / 10000.f;
        
        NSString *str = [NSString stringWithFormat:@"%.2f",flow];
        
        [ary addObject:str];
    
    }
    return @[ary];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown,UUBlue,UULightBlue,UUMauve,UUYellow,UUTwitterColor,UUFreshGreen,UUBlack,UUDarkYellow,UUWeiboColor];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(20,0);
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

////判断显示最大最小值
//- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
//{
//    return YES;
//}
@end
