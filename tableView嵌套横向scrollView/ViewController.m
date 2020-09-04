//
//  ViewController.m
//  tableView嵌套横向scrollView
//
//  Created by fly on 2020/7/10.
//  Copyright © 2020 fly. All rights reserved.
//


/************************************************************
 
 首先是一个父控制器，父控制上添加一个大tableView，头视图就作为tableView的tableHeaderView，这个大tableView只有一个cell，这个cell上添加一个横向滑动的scrollView，scrollView就用来添加若干个子控制器，每个子控制器都有一个tableView。其中，父控制器的大tableView必须实现下面这个手势代理方法:
 
 // 这个方法返回的是否支持多手势，当返回yes时，滑动子控制器中的scrollView时，FLYTableView也能接收滑动事件
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
 }
 
 
然后再在scrollViewDidScroll方法里，调整他们的contentOffset。
 
 ************************************************************/

#import "ViewController.h"
#import "FLYTableView.h"
#import "FLYMenuView.h"
#import "ChildViewController.h"

#define HeaderViewH 150
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController () < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) FLYTableView * baseTableView;
@property (nonatomic, strong) FLYMenuView * menuView;
@property (nonatomic, strong) UIScrollView * horizontalScrollView;

//存放子控制器里的scrollView
@property (nonatomic, strong) UIScrollView *childVCScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(childVCScrollViewDidScroll:) name:FLYScrollViewDidScroll object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - UI

- (void)initUI
{
    //解决scrollview顶部留白20px
    self.baseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [self.view addSubview:self.baseTableView];
    
    
    ChildViewController * firstVC = [[ChildViewController alloc] init];
    ChildViewController * secondVC = [[ChildViewController alloc] init];
    ChildViewController * thirdVC = [[ChildViewController alloc] init];
    [self addChildViewController:firstVC];
    [self addChildViewController:secondVC];
    [self addChildViewController:thirdVC];
    
    //默认加载第一个
    [self.horizontalScrollView addSubview:firstVC.view];
}



#pragma mark - private methods

- (void)changeChildViewController:(NSInteger)tag
{
    [self.horizontalScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * tag, 0) animated:YES];
    
    
    UIViewController * childViewController = self.childViewControllers[tag];
    if ( [childViewController isViewLoaded] )
    {
        return;
    }
    
    childViewController.view.frame = CGRectMake(SCREEN_WIDTH * tag, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.horizontalScrollView addSubview:childViewController.view];
}



#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baseTableViewCell"];
    [cell.contentView addSubview:self.horizontalScrollView];
    return cell;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滑动响应的是最下面的tableView
    if (self.baseTableView == scrollView)
    {

        /*如果子视图没有滑动到顶 或者 最下面的tableView滑动超过HeaderView的高度，
           则不让最下面的tableView滑动，把它的偏移设置成固定值(HeaderView的高度)
         */
        if ( (self.childVCScrollView.contentOffset.y > 0) || (scrollView.contentOffset.y > HeaderViewH) )
        {
            self.baseTableView.contentOffset = CGPointMake(0, HeaderViewH);
        }
        
        
        /*如果最下面tableView的y轴偏移 小于 HeaderView的高度，
           则把子控制器的滚动视图的偏移设置成0
         */
        //这里的y可能被上面修改过了
        if ( scrollView.contentOffset.y < HeaderViewH)
        {
            self.childVCScrollView.contentOffset = CGPointZero;
        }
    }
}



#pragma mark - Notification

//子控制器内的tableview滚动时的通知
- (void)childVCScrollViewDidScroll:(NSNotification *)notification
{
    UIScrollView *scrollView = notification.object;
    self.childVCScrollView = scrollView;

    
    /*如果最下面tableView的y轴偏移 小于 HeaderView的高度，
      则把子控制器的滚动视图的偏移设置成0
     */
    if (self.baseTableView.contentOffset.y < HeaderViewH)
    {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }
    else
    {
        scrollView.showsVerticalScrollIndicator = YES;
    }
}



#pragma mark - setters and getters

-(FLYTableView *)baseTableView
{
    if ( _baseTableView == nil )
    {
        _baseTableView = [[FLYTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _baseTableView.dataSource = self;
        _baseTableView.delegate = self;
        _baseTableView.rowHeight = self.view.frame.size.height;
        [_baseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"baseTableViewCell"];
        _baseTableView.tableHeaderView = self.menuView;
        _baseTableView.showsVerticalScrollIndicator = NO;
    }
    return _baseTableView;
}

-(FLYMenuView *)menuView
{
    if ( _menuView == nil )
    {
        __weak typeof(self) weakSelf = self;
        
        _menuView = [[FLYMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, HeaderViewH)];
        _menuView.backgroundColor = [UIColor yellowColor];
        _menuView.block = ^(NSInteger tag) {
            
            [weakSelf changeChildViewController:tag];
        };
    }
    return _menuView;
}

-(UIScrollView *)horizontalScrollView
{
    if ( _horizontalScrollView == nil )
    {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.scrollEnabled = NO;
        _horizontalScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    }
    return _horizontalScrollView;
}


@end
