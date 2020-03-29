//
//  DTMainTabBarView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTMainTabBarView.h"
#import "DTButton.h"

@implementation DTMainTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bottomLine.mode = BPOnePixLineDirectionTopOrLeft;
        self.bottomLine.top = 0;
        self.bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        self.normalColor = [UIColor colorWithString:@"#333333"];
        self.selectColor = [UIColor colorWithString:@"#FF6464"];
        
        self.selectedLine.hidden = YES;
    }
    return self;
}

- (UIButton *)createItemWithIndex:(NSInteger)index
{
    DTButton *btn = [DTButton buttonWithStyle:DTButtonStyleVertical mode:DTButtonModeImageTitle];
    btn.alignment = DTButtonAlignmentLeftOrTop;
    [(DTButton *)btn setLeftOrTop:(self.height - 24 - 18 - SAFE_BOTTOM_VIEW_HEIGHT) / 2  imageSize:24 titleSize:18 gap:0];
    return btn;
}

- (void)setImages:(NSArray *)images selImages:(NSArray *)selImages
{
    _images = images;
    _selImages = selImages;
}

- (void)setBtn:(UIButton *)btn withIndex:(NSInteger)index
{
    [super setBtn:btn withIndex:index];
    [btn setImageWithImageName:[_images safeObjectAtIndex:index] selImageName:[_selImages safeObjectAtIndex:index]];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    [super setSelectIndex:selectIndex];
}

@end
