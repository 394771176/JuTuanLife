//
//  JTTaskHomeController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTTaskHomeController.h"

@interface JTTaskHomeController () {
    
}

@end

@implementation JTTaskHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableHeader];
    
    [self reloadTableView];
}

- (void)setupTableHeader
{
    UIView *view = UICREATE(UIView, 0, 0, self.view.width, self.view.height * 0.6, AAWH, nil);
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageV = UICREATEImg(UIImageView, 0, 0, 0, 0, AAW, CCCenter, @"jt_no_task", view);
    imageV.frame = CGRectMake(0, (view.height - imageV.height - 60) / 2, view.width, imageV.height);
    
    UILabel *label = UICREATELabel(UILabel, 0, imageV.bottom + 5, view.width, 60, AAW, nil, @"12", @"", view);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:@"现在暂时还没有发布活动内容哦！\n"
     "请耐心等待！" withLineSpace:5];
    
    self.tableView.tableHeaderView = view;
}

@end
