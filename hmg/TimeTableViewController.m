//
//  TimeTableViewController.m
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import "TimeTableViewController.h"
#import "Date.h"
#import "Date+Additions.h"
#import <Foundation/Foundation.h>

@interface BPCell1 : UITableViewCell

@property (nonatomic) UILabel * ID;
@property (nonatomic) UILabel * NAME;

@end

@implementation BPCell1

@synthesize ID = _ID;
@synthesize NAME  = _NAME;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            // Initialization code
        
        [self.contentView addSubview:self.ID];
        [self.contentView addSubview:self.NAME];
        
        [self.contentView addConstraints:[self layoutConstraints]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
        // Configure the view for the selected state
}


#pragma mark - Views

-(UILabel *)ID
{
    if (_ID) return _ID;
    _ID = [UILabel new];
    [_ID setTranslatesAutoresizingMaskIntoConstraints:NO];
    _ID.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _ID;
}

-(UILabel *)NAME
{
    if (_NAME) return _NAME;
    _NAME = [UILabel new];
    [_NAME setTranslatesAutoresizingMaskIntoConstraints:NO];
    _NAME.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _NAME;
}

#pragma mark - Layout Constraints

-(NSArray *)layoutConstraints{
    
    NSMutableArray * result = [NSMutableArray array];
    
    NSDictionary * views = @{ @"id": self.ID,
                              @"name": self.NAME};
    
    
    NSDictionary *metrics = @{@"imgSize":@50.0,
                              @"margin" :@12.0};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[id(imgSize)]-[name]"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[id(imgSize)]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    return result;
}


@end



@interface TimeTableViewController ()

@end

@implementation TimeTableViewController

@synthesize rowDescriptor = __rowDescriptor;
@synthesize popoverController = __popoverController;

static NSString *const kCellIdentifier = @"CellIdentifier";

NSArray *array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
        [self initialize];
    }
    return self;
}

-(void)initialize
{
        // Enable the pagination
    self.loadingPagingEnabled = NO;
    
        // Support Search Controller
    self.supportSearchController = NO;
    
    [self customizeAppearance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    array =[NSArray arrayWithObjects:
            [[Date alloc] initWithID:@"0" andNAME:@"0"],
            [[Date alloc] initWithID:@"1" andNAME:@"1"],
            [[Date alloc] initWithID:@"2" andNAME:@"2"],
            [[Date alloc] initWithID:@"3" andNAME:@"3"],
            [[Date alloc] initWithID:@"4" andNAME:@"4"],
            [[Date alloc] initWithID:@"5" andNAME:@"5"],
            [[Date alloc] initWithID:@"6" andNAME:@"6"],
            [[Date alloc] initWithID:@"7" andNAME:@"7"],
            [[Date alloc] initWithID:@"8" andNAME:@"8"],
            [[Date alloc] initWithID:@"9" andNAME:@"9"],
            [[Date alloc] initWithID:@"10" andNAME:@"10"],
            [[Date alloc] initWithID:@"11" andNAME:@"11"],
            [[Date alloc] initWithID:@"12" andNAME:@"12"],
            [[Date alloc] initWithID:@"13" andNAME:@"13"],
            [[Date alloc] initWithID:@"14" andNAME:@"14"],
            [[Date alloc] initWithID:@"15" andNAME:@"15"],
            [[Date alloc] initWithID:@"16" andNAME:@"16"],
            [[Date alloc] initWithID:@"17" andNAME:@"17"],
            [[Date alloc] initWithID:@"18" andNAME:@"18"],
            [[Date alloc] initWithID:@"19" andNAME:@"19"],
            [[Date alloc] initWithID:@"20" andNAME:@"20"],
            [[Date alloc] initWithID:@"21" andNAME:@"21"],
            [[Date alloc] initWithID:@"22" andNAME:@"22"],
            [[Date alloc] initWithID:@"23" andNAME:@"23"],
            [[Date alloc] initWithID:@"24" andNAME:@"24"],
            nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BPCell1 class] forCellReuseIdentifier:kCellIdentifier];
    
    [self customizeAppearance];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellId";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    Date *model=(Date *)[array objectAtIndex:indexPath.row];
    cell.textLabel.text=model.NAME;
    
    cell.accessoryType = [[self.rowDescriptor.value formValue] isEqual:model.ID] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    if (indexPath.row%2==0) {
        cell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    }
    else
        {
        cell.backgroundColor=[UIColor whiteColor];
        }
    
    cell.layer.masksToBounds=YES;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    //    Agent * agent = nil;
    
        //    if (tableView == self.tableView){
        //        agent = (Agent *)[self.localDataLoader objectAtIndexPath:indexPath];
        //    }
        //    else{
        //        agent = (Agent *)[self.searchLocalDataLoader objectAtIndexPath:indexPath];
        //    }
        //    self.rowDescriptor.value = agent;
    
    Date *model=(Date *)[array objectAtIndex:indexPath.row];
    
    self.rowDescriptor.value=model;
    NSLog(@"%@",model.ID);
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
        
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)loadingPagingEnabled
{
    return NO;
}

    //禁用刷新控件
-(UIRefreshControl *)refreshControl
{
    return nil;
}

#pragma mark - Helpers

-(void)customizeAppearance
{
    [[self navigationItem] setTitle:@"拜访时间"];
    [self.navigationController.navigationBar.backItem setTitle:@""];
        //[self.tableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
        //[self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        //[self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


@end
