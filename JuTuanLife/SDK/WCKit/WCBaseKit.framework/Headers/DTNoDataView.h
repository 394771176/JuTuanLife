//
//  DTNoDataView.h
//  DrivingTest
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCBaseUtil.h"

@class DTNoDataView;

@protocol DTNoDataViewDelegate <NSObject>

- (void)noDataViewDidClick:(DTNoDataView *)view;

@optional
- (void)noDataViewBtnAction:(DTNoDataView *)view;

@end

@interface DTNoDataView : UIView {
#if __has_include(<WCPlugin/FLAnimatedImageView.h>)
    FLAnimatedImageView *_imgView;
#else
    UIImageView *_imgView;
#endif
    UILabel *_msgLabel;
    UIButton *_btn;
}

@property (nonatomic, weak) id<DTNoDataViewDelegate> delegate;

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGFloat imgOffset;//y轴偏移量
@property (nonatomic) CGFloat btnOffset;//y轴偏移量
@property (nonatomic) CGFloat labOffset;//y轴偏移量

- (UIImageView *)getAniImageView;
- (UIButton *)getBtn;
- (UILabel *)getMsgLabel;

- (void)setBtnTitle:(NSString *)btnTitle;

@end
