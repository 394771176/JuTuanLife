//
//  JTLoginAuthController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginAuthController.h"
#import "JTLoginAuthImageCell.h"

@interface JTLoginAuthController ()
<
DTTableButtonCellDelegate
>
{
    NSMutableArray<JTLoginAuthImageCell *> *_cellArray;
}

@end

@implementation JTLoginAuthController

- (void)viewDidLoad {
    
    _cellArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        JTLoginAuthImageCell *cell = [[JTLoginAuthImageCell alloc] init];
        cell.step = i + 1;
        cell.delegate = self;
        [_cellArray safeAddObject:cell];
    }
    
    [super viewDidLoad];
    self.title = @"认证身份";
    self.view.backgroundColor = [UIColor colorWithString:@"f9f9f9"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JTLoginAuthImageCell cellHeightWithItem:nil tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_cellArray safeObjectAtIndex:indexPath.row];
    if (cell) {
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(JTLoginAuthImageCell *)cell
{
    NSInteger step = cell.step;
    NSLog(@"step:%zd", step);
}

@end
