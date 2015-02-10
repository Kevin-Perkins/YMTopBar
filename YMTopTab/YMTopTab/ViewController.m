//
//  ViewController.m
//  YMTopTab
//
//  Created by barryclass on 10/17/14.
//  Copyright (c) 2014 barryclass. All rights reserved.
//

#import "ViewController.h"
#import "YMTopTab.h"

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) YMTopTab *toptab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
   NSArray *titles = @[@"火箭湖人湖人",@"湖人",@"热火",@"火箭湖人湖人",@"湖人",@"热火",@"火箭湖人湖人",@"湖人",@"热火"];
    YMTopTab *topTbas = [[YMTopTab alloc] initWithOrigin:CGPointMake(0, 20) tabsArray:titles titleFont:nil];
    [self.view addSubview:topTbas];
    topTbas.slideColor = [UIColor redColor];
    
    NSArray *titles1 = @[@"火箭湖人",@"湖人"];
    YMTopTab *topTbas1 = [[YMTopTab alloc] initWithOrigin:CGPointMake(0, 80) tabsArray:titles1 titleFont:nil];
    [self.view addSubview:topTbas1];
    topTbas1.slideColor = [UIColor yellowColor];

    NSArray *titles2 = @[@"红色",@"绿色",@"蓝色"];

    YMTopTab *topTbas2 = [[YMTopTab alloc] initWithOrigin:CGPointMake(0, 140) tabsArray:titles2 titleFont:nil];
    topTbas2.titleWidth = 60.0f;
    [self.view addSubview:topTbas2];
    self.toptab = topTbas2;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 220, 320, 200)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(3 * 320, 200);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;

    NSArray *colorArray = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];

    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, 200)];
        view.backgroundColor = colorArray[i % 3];
        [scrollView addSubview:view];
    }
    topTbas2.adpterScrollView =scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.toptab adapterScrollViewScroll:scrollView];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.toptab adapterScrollViewDidEndDecelerating:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
