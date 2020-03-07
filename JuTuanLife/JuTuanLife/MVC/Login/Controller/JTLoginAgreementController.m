//
//  JTLoginAgreementController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginAgreementController.h"
#import "JTLoginProtorolCell.h"

@interface JTLoginAgreementController () {
    NSArray *_protorolsList;
    
    UIView *_bottomView;
    UILabel *_protorolsLabel;
    UIButton *_submitBtn;
    
    BOOL _agree;
}

@end

@implementation JTLoginAgreementController

- (void)viewDidLoad {
    
    _protorolsList = [NSArray arrayWithObjects:
                      [JTProtorolItem itemWithName:@"《聚推帮业务分销代理协议》" link:@""],
                      [JTProtorolItem itemWithName:@"《聚推帮业务提成分润委托声明书》" link:@""],
                      [JTProtorolItem itemWithName:@"《个人所得税扣缴管理方法》" link:@""],
                      [JTProtorolItem itemWithName:@"《聚推帮业务人员诚信展业承诺书》" link:@""],
                      nil];
    
    [super viewDidLoad];
    self.title = @"签署协议";
    
    [self.tableView setTableHeaderHeight:10 footerHeight:12];
    
    [self setupBottomView];
    
    [self reloadTableView];
}

- (void)setupBottomView
{
    if (!_bottomView) {
        CREATE_UI_VV(_bottomView, UIView, 0, self.height - 167 - SAFE_BOTTOM_VIEW_HEIGHT, self.width, 167 + SAFE_BOTTOM_VIEW_HEIGHT);
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(24, _bottomView.height - 16 - 48 - SAFE_BOTTOM_VIEW_HEIGHT, _bottomView.width - 24 * 2, 48);
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [btn addTarget:self action:@selector(submitAction)];
        [btn setBackgroundImageAndHightlightWithColorHex:APP_JT_GRAY_STRING cornerRadius:5];
        [btn setTitle:@"同意并提交签署" fontSize:18 colorString:@"ffffff"];
        [_bottomView addSubview:btn];
        _submitBtn = btn;
        
        _protorolsLabel = [UILabel labelWithFrame:RECT(36, 16, _bottomView.width - 70, btn.top - 24 - 16) fontSize:12 colorString:@"333333"];
        _protorolsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _protorolsLabel.numberOfLines = 0;
        [_bottomView addSubview:_protorolsLabel];
        
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(_protorolsLabel.left - 4, _protorolsLabel.top - 8, 16 + 16, 16 + 16);
            btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [btn addTarget:self action:@selector(clickBoxAction:)];
            [btn setImageWithImageName:@"protorol_unagree" selImageName:@"protorol_agree"];
            [_bottomView addSubview:btn];
        }
    }
}

- (void)updateBottomView
{
    NSMutableString *text = [NSMutableString stringWithString:@"       我已阅读并同意签署"];
    [_protorolsList enumerateObjectsUsingBlock:^(JTProtorolItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name.length) {
            [text appendFormat:@"，%@", obj.name];
        }
    }];
    [text appendString:@"。"];
    
    [_protorolsLabel setText:text withLineSpace:5];
    
    _protorolsLabel.height = [_protorolsLabel getTextHeight];
    
    CGFloat bottomHeight = 16 + _protorolsLabel.height + 24 + 48 + 16 + SAFE_BOTTOM_VIEW_HEIGHT;
    _bottomView.frame = RECT(0, self.height - bottomHeight, self.width, bottomHeight);
    
    self.tableView.height = _bottomView.top;
}

- (void)reloadTableView
{
    [self updateBottomView];
    [super reloadTableView];
}

- (void)submitAction
{
    NSLog(@"submit");
}

- (void)clickBoxAction:(UIButton *)sender
{
    _agree = !_agree;
    [sender setSelected:_agree];
    _submitBtn.userInteractionEnabled = _agree;
    if (_agree) {
        [_submitBtn setBackgroundImageAndHightlightWithColorHex:APP_JT_BLUE_STRING cornerRadius:5];
    } else {
        [_submitBtn setBackgroundImageAndHightlightWithColorHex:APP_JT_GRAY_STRING cornerRadius:5];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _protorolsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_H(JTLoginProtorolCell);
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CELL(JTLoginProtorolCell);
    cell.item = [_protorolsList safeObjectAtIndex:indexPath.row];
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
