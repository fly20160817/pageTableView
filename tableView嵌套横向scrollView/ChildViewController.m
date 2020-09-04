//
//  ChildViewController.m
//  tableView嵌套横向scrollView
//
//  Created by fly on 2020/7/10.
//  Copyright © 2020 fly. All rights reserved.
//


#import "ChildViewController.h"

NSNotificationName const FLYScrollViewDidScroll = @"FLYScrollViewDidScroll";

@interface ChildViewController () < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}



#pragma mark - UI

- (void)initUI
{
    //解决scrollview顶部留白20px
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self.view addSubview:self.tableView];
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", (long)indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动时发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:FLYScrollViewDidScroll object:scrollView];
}



#pragma mark - setters and getters

-(UITableView *)tableView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


@end
