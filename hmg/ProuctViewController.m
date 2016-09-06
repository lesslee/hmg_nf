//
//  ProuctViewController.m
//  hmg
//
//  Created by Hongxianyu on 16/4/28.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "ProuctViewController.h"
#import "MainCell.h"
#import "WeekViewController.h"
#import "ProuctTableViewController.h"
#import "LYChooseTool.h"
#import "prouctSection.h"
#import "Prouct.h"
#import "SoapHelper.h"
#import "CommonResult.h"
#import "Common.h"
#import "INSERT_WEEK_PROMOTION_NEW.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
@interface ProuctViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,PassTrendValueDelegate>
{
    UITableView *_tableView;
    NSMutableArray *selectedArr;//二级列表是否展开状态
    //NSArray  *array1;
    NSArray *array;
    NSString *data;
    
   
    NSString *prouctid;
    NSString *storeid;
    NSString *number;
    prouctSection *section2;
    prouctSection *section1;
    
   
    
}
@property(nonatomic, strong)NSString *StoreID;
@property(nonatomic, strong) NSString *pos_Money;
@end

@implementation ProuctViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.serviceHelper=[[ServiceHelper alloc] initWithDelegate:self];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    self.navigationItem.title=@"产品列表";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:67/255.0 green:177/255.0 blue:215/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleBordered target:self action:@selector(goweek)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar.backItem setTitle:@""];
    
    selectedArr = [[NSMutableArray alloc] init];
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    //不要分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    HUDManager = [[MBProgressHUDManager alloc] initWithView:self.navigationController.view];
}

-(void)passPosMoneyValues:(NSString *)values
{

    self.pos_Money = values;

}
-(void)goweek{
    
    WeekViewController *addVc = [[WeekViewController alloc]init];
    //[self saveNSUserDefaults];
    [self.navigationController pushViewController:addVc animated:YES];
    
}



-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"_StoreID"];
    _StoreID = myString;
    NSLog(@"%@",_StoreID);
    
    NSString *myString1 = [userDefaultes stringForKey:@"data"];
    data = myString1;
    NSLog(@"%@",data);
}

//-(void) saveNSUserDefaults{
//    NSString *data1 = data;
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:data1 forKey:@"data1"];
//    NSLog(@"%@1",data);
//    NSLog(@"%@2",data1);
//    [userDefaults synchronize];
//}

#pragma mark----tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[[LYChooseTool sharedLYChooseTool] dataArray] count];
   
}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    array = [[LYChooseTool sharedLYChooseTool] dataArray];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, 40)];
    titleLabel.text = [[array objectAtIndex:section] NAME];
    [view addSubview:titleLabel];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 15, 20)];
    imageView.tag = 20000+section;
    //判断是不是选中状态
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    if ([selectedArr containsObject:string]) {
        imageView.image = [UIImage imageNamed:@"buddy_header_arrow_down@2x.png"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"buddy_header_arrow_right@2x.png"];
    }
    [view addSubview:imageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 220, 40);
    button.tag = 100+section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(220, 5, 100, 30);
    button1.tag = 200+section;
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"选择产品" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(doButton1:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [view addSubview:button1];
    return view;
}


//每一个表头下返回几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    NSLog(@"%@`````",string);
    
    if ([selectedArr containsObject:string]) {
        
        UIImageView *imageV = (UIImageView *)[_tableView viewWithTag:20000+section];
        imageV.image = [UIImage imageNamed:@"buddy_header_arrow_down@2x.png"];
        
        section1 = [[[LYChooseTool sharedLYChooseTool] dataArray] objectAtIndex:section];
        NSLog(@"%@",section1);
        NSLog(@"%lu3333",(unsigned long)section1.prouctArray.count);
        return section1.prouctArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    prouctSection *productS = [[[LYChooseTool sharedLYChooseTool] dataArray] objectAtIndex:indexPath.section];
    Prouct *prouct = (Prouct *)[productS.prouctArray objectAtIndex:indexPath.row];
    MainCell *cell = [MainCell loadCellViewWithTableView:tableView];
    cell.model = prouct;

    cell.layer.masksToBounds=YES;
    
    return cell;
    
}


//设置表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)doButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",(long)(sender.tag-100)];
    
    //数组selectedArr里面存的数据和表头相对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    
    [_tableView reloadData];
}


-(void)doButton1:(UIButton *)sender{
    
    ProuctTableViewController *pvc = [[ProuctTableViewController alloc]init];
    
    pvc.productModel1 = [[[LYChooseTool sharedLYChooseTool]dataArray]objectAtIndex:sender.tag - 200];
    
    [[[[[LYChooseTool sharedLYChooseTool]dataArray]objectAtIndex:sender.tag - 200]prouctArray]removeAllObjects];
    
    [_tableView reloadData];
    
    [self.navigationController pushViewController:pvc animated:YES];
    
    
}


-(void)save{
//    NSInteger sum = 0;
//    NSString *qty=@"";
//    NSString *proctID=@"";
//    for (int i=0; i<array.count; i++){
//    section2 = [[[LYChooseTool sharedLYChooseTool]dataArray] objectAtIndex:i];
//    sum = [[[[[LYChooseTool sharedLYChooseTool]dataArray] objectAtIndex:i]prouctArray]count];
//        for (int j = 0; j < sum; j++) {
//            NSString *prouctid1 =  [[[section2 prouctArray]objectAtIndex:j]PROD_ID];
//            NSString *qty1 = [[[section2 prouctArray]objectAtIndex:j]count1];
//           
//            proctID = [proctID stringByAppendingString:[NSString stringWithFormat:@"%@#",prouctid1]];
//            qty = [qty stringByAppendingString:[NSString stringWithFormat:@"%@#",qty1]];
//        }
//        
//    }
//    NSLog(@"%@",proctID);
//    NSLog(@"%@",qty);
//    [self communicateServiceWithIN_PROD_ID:proctID andIN_QTY:qty];
    
        NSInteger sum = 0;
        NSString *qty=@"";
        NSString *proctID=@"";
        for (int i=0; i<array.count; i++){
        section2 = [[[LYChooseTool sharedLYChooseTool]dataArray] objectAtIndex:i];
            
            if (section2.prouctArray.count == 0) {
                [HUDManager showMessage:@"请选择产品" duration:1];
            } else {
                sum = [[[[[LYChooseTool sharedLYChooseTool]dataArray] objectAtIndex:i]prouctArray]count];
                for (int j = 0; j < sum; j++) {
                    NSString *prouctid1 =  [[[section2 prouctArray]objectAtIndex:j]PROD_ID];
                    NSString *qty1 = [[[section2 prouctArray]objectAtIndex:j]count1];
                    
                    if (qty1 == nil) {
                        [HUDManager showMessage:@"请输入数量" duration:1];
                    } else {
                        proctID = [proctID stringByAppendingString:[NSString stringWithFormat:@"%@#",prouctid1]];
                        qty = [qty stringByAppendingString:[NSString stringWithFormat:@"%@#",qty1]];
                        [self communicateServiceWithIN_PROD_ID:proctID andIN_QTY:qty];
 
                    }
                    
                }

            }
            
        }
    
        NSLog(@"%@",proctID);
        NSLog(@"%@",qty);
    
  }


-(void) communicateServiceWithIN_PROD_ID:(NSString *) IN_PROD_ID andIN_QTY:(NSString *) IN_QTY
{
    
    Common *common=[[Common alloc] initWithView:self.view];
    
    if (common.isConnectionAvailable) {
    //[HUDManager showMessage:@"正在提交"];
     [self readNSUserDefaults];
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    INSERT_WEEK_PROMOTION_NEW *param=[[INSERT_WEEK_PROMOTION_NEW alloc] init];
    param.IN_PROD_ID = IN_PROD_ID;
    param.IN_QTY = IN_QTY;
    param.IN_STORE_ID = _StoreID;
    param.IN_PROM_DTM = data;
    param.IN_INP_USER = appDelegate.userInfo.EMP_NO;
    param.IN_POS_MONEY = self.pos_Money;
    NSLog(@"%@",param.IN_POS_MONEY);
    NSLog(@"%@",param.IN_INP_USER);
    NSString *paramXml=[SoapHelper objToDefaultSoapMessage:param];
   
    [self.serviceHelper resetQueue];
    ASIHTTPRequest *request1=[ServiceHelper commonSharedRequestMethod:@"INSERT_WEEK_PROMOTION_NEW" soapMessage:paramXml];
    [request1 setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"INSERT_WEEK_PROMOTION_NEW",@"name", nil]];
    [self.serviceHelper addRequestQueue:request1];
    
    [self.serviceHelper startQueue];
    }
}

#pragma ---------------调用服务代码-------------------

-(void) finishQueueComplete
{
    
}

-(void) finishSingleRequestFailed:(NSError *)error userInfo:(NSDictionary *)dic
{
    //error.description
    [HUDManager showErrorWithMessage:@"网络错误" duration:1];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void) finishSingleRequestSuccess:(NSData *)xml userInfo:(NSDictionary *)dic
{
    /**保存周末促接口**/
    if ([@"INSERT_WEEK_PROMOTION_NEW" isEqualToString:[dic objectForKey:@"name"]]) {
        CommonResult *result4=[[CommonResult alloc] init];
        NSMutableArray *array22 =[[NSMutableArray alloc] init];
        [array22 addObjectsFromArray:[result4 searchNodeToArray:xml nodeName:@"NewDataSet"]];
        if ([result4.OUT_RESULT isEqualToString:@"0"]) {
            [HUDManager showSuccessWithMessage:@"上传成功" duration:1 complection:^{
                [[LYChooseTool sharedLYChooseTool] destroy];
                
                [_tableView reloadData];
               
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
            
        }
        else
        {
            [HUDManager showSuccessWithMessage:result4.OUT_RESULT_NM duration:1 complection:^{
                [[LYChooseTool sharedLYChooseTool] destroy];
                [_tableView reloadData];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end