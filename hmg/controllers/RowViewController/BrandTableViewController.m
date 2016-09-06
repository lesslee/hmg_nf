    //
    //  BrandTableViewController.m
    //  hmg
    //
    //  Created by Lee on 15/3/30.
    //  Copyright (c) 2015年 com.lz. All rights reserved.
    //

#import "BrandTableViewController.h"
#import "Brand.h"
#import "Brand+Additions.h"
#import <Foundation/Foundation.h>
@interface BPCell2 : UITableViewCell

@property (nonatomic) UILabel * brandID;
@property (nonatomic) UILabel * brandNAME;

@end

@implementation BPCell2

@synthesize brandID = _brandID;
@synthesize brandNAME  = _brandNAME;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            // Initialization code
        
        [self.contentView addSubview:self.brandID];
        [self.contentView addSubview:self.brandNAME];
        
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
    if (_brandID) return _brandID;
    _brandID = [UILabel new];
    [_brandID setTranslatesAutoresizingMaskIntoConstraints:NO];
    _brandID.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _brandID;
}

-(UILabel *)NAME
{
    if (_brandNAME) return _brandNAME;
    _brandNAME = [UILabel new];
    [_brandNAME setTranslatesAutoresizingMaskIntoConstraints:NO];
    _brandNAME.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _brandNAME;
}

#pragma mark - Layout Constraints

-(NSArray *)layoutConstraints{
    
    NSMutableArray * result = [NSMutableArray array];
    
    NSDictionary * views = @{ @"id": self.brandID,
                              @"name": self.brandNAME};
    
    
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

@implementation BrandTableViewController

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
            [[Brand alloc] initWithID:@"C5609" andNAME:@"妈咪爱奶粉伴侣"],
            //[[Brand alloc] initWithID:@"C5702" andNAME:@"80P益生菌"],
            [[Brand alloc] initWithID:@"C5606" andNAME:@"ofmom妈咪爱护系列"],
            [[Brand alloc] initWithID:@"C5607" andNAME:@"ofmom妈咪爱慧系列"],
            [[Brand alloc] initWithID:@"C5608" andNAME:@"ofmom妈咪爱健系列"],
            nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BPCell2 class] forCellReuseIdentifier:kCellIdentifier];
    
    [self customizeAppearance];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"cellId";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    Brand *model=(Brand *)[array objectAtIndex:indexPath.row];
    cell.textLabel.text=model.brandNAME;
    
    cell.accessoryType = [[self.rowDescriptor.value formValue] isEqual:model.brandID] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
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
    
    Brand *model=(Brand *)[array objectAtIndex:indexPath.row];
    
    self.rowDescriptor.value=model;
    NSLog(@"%@",model.brandID);
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
    [[self navigationItem] setTitle:@"品牌"];
    [self.navigationController.navigationBar.backItem setTitle:@""];
        //[self.tableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
        //[self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        //[self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


@end
