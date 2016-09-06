//
//  storeMonthViewController.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "storeMonthViewController.h"
#import "addMonthReportViewController.h"
#import "NF_SALESREPORT_QUERY.h"
#import "AppDelegate.h"
#import "SoapHelper.h"
#import "ServiceHelper.h"
#import "Common.h"
#import "ASINetworkQueue.h"
#import "MonthReport.h"

#import "DetailMonthReport.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define MainColor [UIColor colorWithRed:62.0/255.0 green:162.0/255.0 blue:232.0/255.0 alpha:1.0]

ASIHTTPRequest *request1;

const int pageSize=50;
@interface storeMonthViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int currentPage;
    int Max_Count;
    BOOL isRefresh;
    NSString *string;
}

@property (strong,nonatomic) UIPickerView *datePicker;
@property (strong,nonatomic) UIView*timeSelectView;
@property (strong,nonatomic) UIButton *timeButtonLabel;
@property (strong,nonatomic) UIButton *cancelSelectTimeButton;
@property (strong,nonatomic) UIButton *determineSelectTimeButton;
@property (strong,nonatomic) NSMutableArray *myArray1;
@property (strong,nonatomic) NSMutableArray *myArray;
@property (strong,nonatomic) NSString  *timeSelectedString;
@property (strong,nonatomic) NSString  *str10;
@property (strong,nonatomic) NSString  *str11;


@property (nonatomic,strong)CLLRefreshHeadController *refreshControll;
    //销售月报集合
@property (nonatomic, strong) NSMutableArray *monthReports;
@property (nonatomic) NSInteger pageSize;
@end

@implementation storeMonthViewController



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
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 56, 40, 55)];
    lable.text = @"日期:";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(260, 55, 60, 55);
    [button setUserInteractionEnabled:YES];
    button.layer.cornerRadius=5;
    button.layer.masksToBounds=YES;

    [button setTitle:@"查询" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        //初始时间选择文字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    self.str10 = [formatter stringFromDate:[NSDate date]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    self.str11 = [formatter1 stringFromDate:[NSDate date]];
    self.timeSelectedString = [NSString stringWithFormat:@"%@%@",self.str11,self.str10];
        //设置pickerview初始默认
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"yyyy"];
    NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
    int a = [str111 intValue];
    int b = [str222 intValue];
    [self.datePicker selectRow:a-1 inComponent:1 animated:NO];
    [self.datePicker selectRow:b-1900 inComponent:0 animated:NO];
    [self.view addSubview:lable];
    [self.view addSubview:button];
    [self.view addSubview:self.timeButtonLabel];
    [self.view addSubview:self.timeSelectView];
    
    
    NSLog(@"%@123",self.timeButtonLabel.titleLabel.text);
    
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.monthReports=[[NSMutableArray alloc] init];
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 110,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-110)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.dataSource=self;
    tableView.delegate=self;
    
        //[HUDManager showMessage:@"加载中..."];
    
        [self.refreshControll startPullDownRefreshing];
}


-(UIButton *)timeButtonLabel{
    if (!_timeButtonLabel) {
        _timeButtonLabel = [[UIButton alloc]initWithFrame:CGRectMake(50, 56, 200, 55)];
        [_timeButtonLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMM"];
        NSString *str10 = [formatter stringFromDate:[NSDate date]];
        [_timeButtonLabel setTitle:str10 forState:UIControlStateNormal];
        [_timeButtonLabel addTarget:self action:@selector(timeSelectedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeButtonLabel;
}

-(void)timeSelectedButtonAction{
    
    
    [self.view addSubview:self.timeSelectView];
    [UIView animateWithDuration:0.3 animations:^{
        self.timeSelectView.frame = CGRectMake(0, SCREENHEIGHT-315, SCREENWIDTH, 316);
    }];
}



#pragma  mark - timeSelected
-(UIView *)timeSelectView{
    if (!_timeSelectView) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        label.text = @"时间选择";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        
        _timeSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 316)];
        _timeSelectView.backgroundColor = [UIColor whiteColor];
        [_timeSelectView addSubview:label];
        [_timeSelectView addSubview:self.datePicker];
        [_timeSelectView addSubview:self.cancelSelectTimeButton];
        [_timeSelectView addSubview:self.determineSelectTimeButton];
    }
    return _timeSelectView;
}
-(UIPickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 150)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

-(UIButton *)cancelSelectTimeButton{
    if (!_cancelSelectTimeButton) {
        _cancelSelectTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 80, 40)];
        _cancelSelectTimeButton.backgroundColor = MainColor;
        _cancelSelectTimeButton.layer.cornerRadius = 5;
        _cancelSelectTimeButton.layer.masksToBounds = YES;
        [_cancelSelectTimeButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelSelectTimeButton addTarget:self action:@selector(cancelSelectTimeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelSelectTimeButton;
}


-(UIButton *)determineSelectTimeButton{
    if (!_determineSelectTimeButton) {
        _determineSelectTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 200, 80, 40)];
        _determineSelectTimeButton.backgroundColor = MainColor;
        _determineSelectTimeButton.layer.cornerRadius = 5;
        _determineSelectTimeButton.layer.masksToBounds = YES;
        [_determineSelectTimeButton setTitle:@"确定" forState:UIControlStateNormal];
        [_determineSelectTimeButton addTarget:self action:@selector(determineSelectTimeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineSelectTimeButton;
}

-(void)cancelSelectTimeButtonAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.timeSelectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 316);
    }];
    
}


-(void)determineSelectTimeButtonAction{
    [self.timeButtonLabel setTitle:self.timeSelectedString forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.timeSelectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 316);
    }];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        self.str11 = self.myArray[row];
    }else{
        self.str10 = self.myArray1[row];
    }
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"yyyy"];
    NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
    int a = [str111 intValue];
    int b = [str222 intValue];
    int c = [self.str10 intValue];
    int d = [self.str11 intValue];
    if (d>b||(d==b&&c>a)) {
        [self.datePicker selectRow:a-1 inComponent:1 animated:YES];
        [self.datePicker selectRow:b-1900 inComponent:0 animated:YES];
    }
    
    self.timeSelectedString = [NSString stringWithFormat:@"%@%@",self.str11,self.str10];
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 200;
    }else {
        return 12;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  self.myArray[row];
    }else {
        return  self.myArray1[row];
    }
}


-(NSMutableArray *)myArray1{
    if (!_myArray1) {
        self.myArray1 = [[NSMutableArray alloc]init];
        for (int i = 1; i<13; i++) {
            if (i>9) {
                NSString *str = [NSString stringWithFormat:@"%d%@",i,@"月"];
                [self.myArray1 addObject:str];

            } else {
                 NSString *str = [NSString stringWithFormat:@"0%d%@",i,@"月"];
                [self.myArray1 addObject:str];

            }
                //NSString *str = [NSString stringWithFormat:@"0%d%@",i,@"月"];
                // [self.myArray1 addObject:str];
        }
    }
    return _myArray1;
}
-(NSMutableArray *)myArray{
    if (!_myArray) {
        self.myArray = [[NSMutableArray alloc]init];
        for (int i = 1900; i<2100; i++) {
            NSString *str = [NSString stringWithFormat:@"%d%@",i,@"年"];
            [self.myArray addObject:str];
        }
    }
    return _myArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.serviceHelper) {
        
        self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    }
    
    [self.navigationItem setTitle:@"门店销售月报"];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleBordered target:self action:@selector(newMonthReport)];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
        //self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.refreshControll startPullDownRefreshing];
    [self.monthReports removeAllObjects];
    [tableView reloadData];
    
}



-(void)search{
    
        //[HUDManager showMessage:@"加载中..."];
    [self.refreshControll startPullDownRefreshing];
    [self.monthReports removeAllObjects];
    [tableView reloadData];
}


    //新建月报
-(void)newMonthReport{

    addMonthReportViewController *vc = [[addMonthReportViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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

#pragma 请求服务器结果

-(void) finishQueueComplete
{
    
}



-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
        //[HUDManager showErrorWithMessage:@"网络错误" duration:1];
        //NSLog(@"---------------------------------");
        //NSLog(@"%@",error.localizedFailureReason);
}

    //请求成功，解析结果
-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    @try {
        if(self)
            {
//            /**查询大区**/
//            if ([@"HMG_AREA_QUERY" isEqualToString:[dic objectForKey:@"name"]]) {
//                AreaModel *tempArea=[[AreaModel alloc] init];
//                [self.areas addObjectsFromArray:[tempArea searchNodeToArray:xml nodeName:@"NewDataSet"]];
//                
//            }
//            /**查询部门**/
//            if ([@"HMG_DEPT_QUERY" isEqualToString:[dic objectForKey:@"name"]])
//                {
//                DeptModel *tempDept=[[DeptModel alloc] init];
//                [self.depts addObjectsFromArray:[tempDept searchNodeToArray:xml nodeName:@"NewDataSet"]];
//                }
//            /**查询人员**/
//            if ([@"HMG_USER_QUERY" isEqualToString:[dic objectForKey:@"name"]])
//                {
//                UserModel *tempUser=[[UserModel alloc] init];
//                [self.users addObjectsFromArray:[tempUser searchNodeToArray:xml nodeName:@"NewDataSet"]];
//                }
            /**查询日报**/
            if ([@"NF_SALESREPORT_QUERY" isEqualToString:[dic objectForKey:@"name"]])
                {
               MonthReport  *tempReport=[[MonthReport alloc] init];
                if (isRefresh) {
                    [self.monthReports removeAllObjects];
                    [self.monthReports addObjectsFromArray:[tempReport searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullDownRefreshing];
                }
                else
                    {
                    [self.monthReports addObjectsFromArray:[tempReport searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    [self.refreshControll endPullUpLoading];
                    }
                
                if (self.monthReports.count>0) {
                    MonthReport *model0=(MonthReport *)[self.monthReports objectAtIndex:0];
                    Max_Count=[model0.TOTAL_RECORDS intValue];
                    NSLog(@"%@",model0.TOTAL_RECORDS);
                }
                
                [tableView reloadData];
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
    return self.monthReports.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonthReportCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MonthReportCell"];
    
    if (!cell)
        {
        [tableView registerNib:[UINib nibWithNibName:@"MonthReportCell" bundle:nil] forCellReuseIdentifier:@"MonthReportCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MonthReportCell"];
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
    MonthReportCell *tempCell=(MonthReportCell*)cell;
    
    MonthReport *reportModel=(MonthReport*)[self.monthReports objectAtIndex:indexPath.row];
//    if (self.monthReports.count == 0) {
//        tempCell.inventory.text = @"";
//        tempCell.salesqty.text = @"";
//        tempCell.Inventory.text = @"";
//        tempCell.SalesQty.text = @"";
//        
//    } else if(self.monthReports.count > 0) {
//        tempCell.storeName.text = reportModel.STORE_NM;
//        tempCell.brandName.text=reportModel.PRODUCT_NM;
//        tempCell.Inventory.text=reportModel.INVENTORY;
//        tempCell.SalesQty.text=reportModel.SALES_QTY;
//
//    }
    tempCell.storeName.text = reportModel.STORE_NM;
    tempCell.brandName.text=reportModel.PRODUCT_NM;
    tempCell.Inventory.text=reportModel.INVENTORY;
    tempCell.SalesQty.text=reportModel.SALES_QTY;
    
        //NSLog(@"%@,%@========",reportModel.PRODUCT_ID,reportModel.STORE_ID);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

AppDelegate *delegate=[UIApplication sharedApplication].delegate;
   NSString *date = delegate.userInfo.V_MONTH;
    
    NSString  *month = [date substringWithRange:NSMakeRange(4, 2)];
            NSLog(@"%@",month);
           int month1 = [month intValue];
            NSLog(@"%d",month1);
    MonthReport *reportModel=(MonthReport*)[self.monthReports objectAtIndex:indexPath.row];
    NSString *date1 = reportModel.MONTH;
    NSString  *month2 = [date1 substringWithRange:NSMakeRange(4, 2)];
            NSLog(@"%@",month2);
           int month3 = [month intValue];
            NSLog(@"%d",month3);
    NSLog(@"%d,%d",month1,month3);
   
   NSString *storeName = reportModel.STORE_NM;
    NSString *brandName = reportModel.PRODUCT_NM;
    NSString *invertoy = reportModel.INVENTORY;
    NSString *sealQty = reportModel.SALES_QTY;
    NSString *storeID = reportModel.STORE_ID;
    NSString *name = reportModel.EMP_NM;
    NSLog(@"%@",name);
    NSLog(@"%@",storeID);
    NSString *brandId = reportModel.PRODUCT_ID;
    NSLog(@"%@",brandId);
    NSLog(@"%@,%@,%@,%@,%@,%@00",storeName,brandName,invertoy,sealQty,storeID,brandId);
    if (month1 == month3) {
        DetailMonthReport *dm = [[DetailMonthReport alloc]init];
        
        self.trendMonthDelegate=dm; //设置代理
        
        [self.trendMonthDelegate passTrendValues:storeName AndBrandName:brandName AndInvertoy:invertoy AndSealQty:sealQty AndStoreID:storeID AndBrandID:brandId];

        [self.navigationController pushViewController:dm animated:YES];
    } else {
        [HUDManager showMessage:@"只能修改本月销售月报" duration:1];
    }
}



#pragma 刷新控件

- (BOOL)hasRefreshFooterView {
    if (self.monthReports.count > 0 && self.monthReports.count < Max_Count) {
        
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
    
        //[HUDManager showMessage:@"加载中..."];
    isRefresh=YES;
    currentPage=1;
        //[self setCanBack:NO];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3];
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
       AppDelegate *delegate=[UIApplication sharedApplication].delegate;
       NF_SALESREPORT_QUERY  *reportParam=[[NF_SALESREPORT_QUERY alloc] init];
        
        
        NSString *date = self.timeButtonLabel.titleLabel.text;
        NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
        NSLog(@"%@11",year);
        NSString *month = [date substringWithRange:NSMakeRange(4,2)];
        NSLog(@"%@1111",month);
        string = [year stringByAppendingString:month];

        reportParam.IN_MONTH = string;
        reportParam.IN_EMP_NO=delegate.userInfo.EMP_NO;
        reportParam.IN_DEPT_CD=delegate.userInfo.DEPT_CD;
        reportParam.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        reportParam.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
            //NSLog(@"%@,%@,%@",reportParam.IN_AREA_ID,reportParam.IN_DEPT_ID,reportParam.IN_EMP_NO);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:reportParam];
        NSLog(@"%@",paramXml);
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod1:@"NF_SALESREPORT_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"NF_SALESREPORT_QUERY",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
}
- (void)endLoadMore {
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
        currentPage ++;
        NF_SALESREPORT_QUERY *reportParam=[[NF_SALESREPORT_QUERY alloc] init];
//        if (self.selectArea==nil) {
//            reportParam.IN_AREA_ID=@"";
//        }
//        else
//            {
//            if ([self.selectArea.DEPT_ID isEqualToString:@"0"]) {
//                reportParam.IN_AREA_ID=@"";
//            }else
//                {
//                reportParam.IN_AREA_ID=self.selectArea.DEPT_ID;
//                }
//            }
//        if (self.selectDept==nil) {
//            reportParam.IN_DEPT_ID=@"";
//        }
//        else
//            {
//            if ([self.selectDept.DEPT_ID isEqualToString:@"0"]) {
//                reportParam.IN_DEPT_ID=@"";
//            }else
//                {
//                reportParam.IN_DEPT_ID=self.selectDept.DEPT_ID;
//                }
//            }
//        if (self.selectUser==nil) {
//            reportParam.IN_EMP_NO=@"";
//        }
//        else
//            {
//            if ([self.selectUser.PERNR isEqualToString:@"0"]) {
//                reportParam.IN_EMP_NO=@"";
//            }else
//                {
//                reportParam.IN_EMP_NO=self.selectUser.PERNR;
//                }
//            }
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        NSString *date = self.timeButtonLabel.titleLabel.text;
        NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
        NSLog(@"%@11",year);
        NSString *month = [date substringWithRange:NSMakeRange(4,2)];
        NSLog(@"%@1111",month);
        string = [year stringByAppendingString:month];

        reportParam.IN_MONTH = string;
        reportParam.IN_EMP_NO=delegate.userInfo.EMP_NO;
        reportParam.IN_DEPT_CD=delegate.userInfo.DEPT_CD;
        reportParam.IN_CURRENT_PAGE=[[NSNumber numberWithInt:currentPage] stringValue];
        reportParam.IN_PAGE_SIZE=[[NSNumber numberWithInt:pageSize] stringValue];
        
            //NSLog(@"%@,%@,%@",reportParam.IN_AREA_ID,reportParam.IN_DEPT_ID,reportParam.IN_EMP_NO);
        
        NSString *paramXml=[SoapHelper objToDefaultSoapMessage:reportParam];
            //NSLog(@"%@",paramXml);
        [self.serviceHelper resetQueue];
        
        request1=[ServiceHelper commonSharedRequestMethod1:@"NF_SALESREPORT_QUERY" soapMessage:paramXml];
        [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"NF_SALESREPORT_QUERY",@"name", nil]];
        
        [self.serviceHelper addRequestQueue:request1];
        
        [self.serviceHelper startQueue];
    }
    
}

@end
