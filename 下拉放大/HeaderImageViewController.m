
//
//  HeaderImageViewController.m
//  下拉放大
//
//  Created by peaker on 2017/3/1.
//  Copyright © 2017年 peaker. All rights reserved.
//

#import "HeaderImageViewController.h"
#import "UIView+HMObjcSugar.h"

NSString *const cellID = @"cellid";
#define kHeaderViewHeight 200

@interface HeaderImageViewController ()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation HeaderImageViewController{
    UIView *_headerView;
    UIImageView *_headerImageView;
    UIStatusBarStyle statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTableView];
    [self prepareHeaderView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return statusBarStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)prepareTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    // 右边的滑动指示器也跟着变动
    tableView.scrollIndicatorInsets = tableView.contentInset;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)prepareHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewHeight)];
    _headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_headerView];
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.frame = _headerView.frame;
    _headerImageView.backgroundColor = [UIColor cyanColor];
    [_headerView addSubview:_headerImageView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 一开始是没有偏移的
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
//    NSLog(@"%f", offset);
    
    
    if (offset <= 0) {
        _headerView.hm_y = 0;
        _headerView.hm_height = kHeaderViewHeight - offset;
        _headerImageView.hm_y = _headerView.hm_y;
        _headerImageView.hm_height = _headerView.hm_height;
        statusBarStyle = UIStatusBarStyleLightContent;
        
    }else {
        // 最小的偏移量。不能超过这个
        CGFloat min = kHeaderViewHeight - 64;
        
        _headerView.hm_y = -MIN(min, offset);
        _headerView.hm_height = kHeaderViewHeight;
        
        NSLog(@"%f", offset/min);
        CGFloat progress = 1 - (offset / min);
        _headerImageView.alpha = progress;
        
        statusBarStyle = UIStatusBarStyleDefault;
//        _headerView.alpha = progress;
    }
    
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
}


@end
