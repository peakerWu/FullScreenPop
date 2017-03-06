//
//  ViewController.m
//  下拉放大
//
//  Created by peaker on 2017/3/1.
//  Copyright © 2017年 peaker. All rights reserved.
//

#import "ViewController.h"
#import "HeaderImageViewController.h"
#import "UINavigationController+ObjSugar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"title";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 避免使用 self.navigationController.navigationBar.hidden
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)item:(id)sender {
    
    HeaderImageViewController *headerVC = [[HeaderImageViewController alloc] init];
    
    [self.navigationController pushViewController:headerVC animated:YES];
}


@end
