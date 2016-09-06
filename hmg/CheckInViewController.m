//
//  CheckInViewController.m
//  hmg
//
//  Created by Lee on 15/5/12.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "CheckInViewController.h"
#import "XLForm.h"
#import "AgentTableViewController.h"
#import "StoreTableViewController.h"
#import "HMG_CHECK_IN.h"
#import "AppDelegate.h"
#import "Store.h"
#import "Agent.h"
#import "SoapHelper.h"
#import "Common.h"
#import "CommonResult.h"
#import "MenuViewController.h"
#import "HMG_CHECK_IN_LAST.h"
#import "MKMapView+MapViewUtil.h"
#import <MapKit/MapKit.h>
@interface CheckInViewController ()

@end

//门店或经销商
NSString *const kSelectorStore1 = @"selectorStore";
//拜访类型
NSString *const kSwitchBool1 = @"switchBool";

@implementation CheckInViewController

XLFormDescriptor * formDescriptor;
XLFormSectionDescriptor * section;
XLFormRowDescriptor * row;

//ServiceHelper *serviceHelper;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    
    return self;
}

-(void)initializeForm
{
    
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"考勤"];
    
    section=[XLFormSectionDescriptor formSection];
    
    [formDescriptor addFormSection:section];
    
    row=[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchBool1 rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"考勤类型"];
    [row.cellConfig setObject:[UIColor colorWithRed:49.0/255.0 green:148.0 / 255.0 blue:208.0 / 255.0 alpha:1.0] forKey:@"segmentedControl.tintColor"];
    row.selectorOptions = @[@"门店",@"经销商"];
    row.value = @"门店";
    [section addFormRow:row];
    
        //添加监听
    [row addObserver:self forKeyPath:@"value" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorStore1 rowType:XLFormRowDescriptorTypeSelectorPush title:@"门店"];
    row.selectorControllerClass = [StoreTableViewController class];
    [section addFormRow:row];
    
    self.form = formDescriptor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"门店或经销商考勤";
    
    //[self.navigationController.navigationBar.backItem setTitle:@""];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
   // self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"考勤" style:UIBarButtonItemStyleBordered target:self action:@selector(checkIn)];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写键值监听方法，切换门店与经销商
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        //BOOL value=[[change objectForKey:@"new"] boolValue];
    XLFormRowDescriptor *switchRow=[self.form formRowWithTag:kSelectorStore1];
    XLFormRowDescriptor *storeRow = [self.form formRowWithTag:kSwitchBool1];

    if ([storeRow.value isEqualToString:@"经销商"]) {
        switchRow.title = @"经销商";
        switchRow.selectorControllerClass = [AgentTableViewController class];
    }else if ([storeRow.value isEqualToString:@"门店"]){
    
    switchRow.title = @"门店";
        switchRow.selectorControllerClass = [StoreTableViewController class];
    
    }
    
        //    if (!value) {
//        
//        switchRow.title=@"门店";
//        switchRow.selectorControllerClass=[StoreTableViewController class];
//    }
//    else
//    {
//        switchRow.title=@"经销商";
//        switchRow.selectorControllerClass=[AgentTableViewController class];
//    }
    
    switchRow.value=nil;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

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
            /**hmg考勤**/
            if ([@"HMG_CHECK_IN_LAST" isEqualToString:[dic objectForKey:@"name"]]) {
                
                    CommonResult *result=[[CommonResult alloc] init];
                    NSMutableArray *array =[[NSMutableArray alloc] init];
                    [array addObjectsFromArray:[result searchNodeToArray:xml nodeName:@"NewDataSet"]];
                    
                if ([result.OUT_RESULT isEqualToString:@"0"]) {
                    [HUDManager showSuccessWithMessage:@"考勤成功" duration:1 complection:^{
                        
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        
//                        for (UIViewController *viewController in self.navigationController.viewControllers) {
//                            if ([viewController isKindOfClass:[MenuViewController class]]) {
//                                [self.navigationController popToViewController:viewController animated:YES];
//                            }
//                        }
                    }];
                    
                }
                else
                {
                    [HUDManager showSuccessWithMessage:result.OUT_RESULT_NM duration:1 complection:^{
                        NSLog(@"%@",result.OUT_RESULT_NM);
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    }];
                }
                

            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@%@",[exception name],[exception reason]);
    }
    @finally {
        
    }
}

//返回
-(void) goBack
{
    [self.serviceHelper resetQueue];
    //移除kvo
    
    [HUDManager hide];
    [[self.form formRowWithTag:kSwitchBool1] removeObserver:self forKeyPath:@"value" context:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//经销货门店考勤
-(void) checkIn
{
    if (![self.form formRowWithTag:kSelectorStore1].value) {
        [HUDManager showMessage:@"请选择门店或经销商" duration:2];
    }
    else
    {
        [HUDManager showMessage:@"考勤中..."];
        
        Common *common=[[Common alloc] initWithView:self.view];
        
        if (common.isConnectionAvailable) {
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            
            HMG_CHECK_IN_LAST *param=[[HMG_CHECK_IN_LAST alloc] init];
            param.IN_EMP_NO=appDelegate.userInfo.EMP_NO;
            param.IN_GPS_LAT=self.LAT;
            
            param.IN_GPS_LON=self.LON;
            NSLog(@"%@,%@", param.IN_GPS_LAT ,param.IN_GPS_LON);
            
            double in_gps_lat = [param.IN_GPS_LAT doubleValue];
            double in_gps_lon = [param.IN_GPS_LON doubleValue];
            
            param.IN_ERROR_CODE = @"";
            if ([[self.form formRowWithTag:kSwitchBool1].value isEqualToString:@"门店"]) {
                Store *tmpStore= [self.form formRowWithTag:kSelectorStore1].value;
                param.IN_STORE_ID=tmpStore.STORE_ID;
                param.IN_BENCHMARK_LON = tmpStore.GPS_LON;
                param.IN_BENCHMARK_LAT = tmpStore.GPS_LAT;
                param.IN_ADDRESS = tmpStore.ADDR;
                NSLog(@"%@",param.IN_ADDRESS);
                NSLog(@"%@0-0,%@",param.IN_BENCHMARK_LON,param.IN_BENCHMARK_LAT);
                param.IN_AGENT_ID=@"";
                double in_gps_lat1 = [param.IN_BENCHMARK_LAT doubleValue];
                double in_gps_lon1 = [param.IN_BENCHMARK_LON doubleValue];
                
                if (in_gps_lat1 == 0 || in_gps_lon1 == 0) {
                    param.IN_DISTANCE = @"";
                    param.IN_DISTANCE_DESCRIPTION = @"无坐标";
                    NSLog(@"%@",param.IN_DISTANCE_DESCRIPTION);
                } else {
                    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(in_gps_lat,in_gps_lon));
                    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(in_gps_lat1,in_gps_lon1));
                    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
                    NSLog(@"%f",distance);
                    NSString *distance1 = [NSString stringWithFormat:@"%f",distance];
                    param.IN_DISTANCE = distance1;
                    param.IN_DISTANCE_DESCRIPTION = @"";
                    NSLog(@"%@",param.IN_DISTANCE_DESCRIPTION);
                }
                
            }else{
                Agent *tmpAgent= [self.form formRowWithTag:kSelectorStore1].value;
                param.IN_STORE_ID=@"";
                param.IN_AGENT_ID=tmpAgent.AGENT_ID;
                param.IN_BENCHMARK_LON = tmpAgent.GPS_LON;
                param.IN_BENCHMARK_LAT = tmpAgent.GPS_LAT;
                param.IN_ADDRESS = tmpAgent.ADDR;
                double in_gps_lat2 = [param.IN_BENCHMARK_LAT doubleValue];
                double in_gps_lon2 = [param.IN_BENCHMARK_LON doubleValue];
                NSLog(@"%f,%f",in_gps_lon2,in_gps_lat2);
                
                if (in_gps_lat2 == 0 || in_gps_lon2 == 0) {
                    param.IN_DISTANCE = @"";
                    param.IN_DISTANCE_DESCRIPTION = @"无坐标";
                    NSLog(@"%@",param.IN_DISTANCE_DESCRIPTION);
                } else {
                    
                    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(in_gps_lat,in_gps_lon));
                    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(in_gps_lat2,in_gps_lon2));
                    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);

                    NSString *distance1 = [NSString stringWithFormat:@"%f",distance];
                    param.IN_DISTANCE = distance1;
                    NSLog(@"%@",distance1);

                    param.IN_DISTANCE_DESCRIPTION =@"";
                    NSLog(@"%@",param.IN_DISTANCE_DESCRIPTION);
                }
                
            }
            
            NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
            
            [self.serviceHelper resetQueue];
            
            ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"HMG_CHECK_IN_LAST" soapMessage:paramXml];
            [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"HMG_CHECK_IN_LAST",@"name", nil]];
            [self.serviceHelper addRequestQueue:request1];
            
            [self.serviceHelper startQueue];
        }
    }
    
    
}


@end
