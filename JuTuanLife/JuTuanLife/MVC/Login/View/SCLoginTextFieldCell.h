//
//  SCLoginPhoneCell.h
//  SuperCoach
//
//  Created by cheng on 17/4/27.
//  Copyright © 2017年 Lin Feihong. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "DTButton.h"

typedef enum {
    SCLoginTextFieldTypeDefault = 0,
    SCLoginTextFieldTypePhone,
    SCLoginTextFieldTypeCode,
    SCLoginTextFieldTypePassword,
}SCLoginTextFieldType;

typedef NS_ENUM(NSInteger, SCCodeBtnStatus) {
    SCCodeBtnStatusNormal = 0,//正常
    SCCodeBtnStatusRequest,//请求中 不可点击
    SCCodeBtnStatusWait,//等待倒计时 不可点击
    SCCodeBtnStatusReset,//重新发送
};

@class SCLoginTextFieldCell, SCCodeBtn;

@protocol SCLoginTextFieldCellDelegate <NSObject>

@optional
- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidReturn:(UITextField *)textField;
- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidChange:(UITextField *)textField;

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell didCodeBtn:(SCCodeBtn *)sender;

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell didDownArrowBtn:(SCCodeBtn *)sender;


@end

@interface SCLoginTextFieldCell : DTTableCustomCell <UITextFieldDelegate>
{
    @protected
    UIView *_bodyView;
    UIImageView *_iconView;
}

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *icon;

@property (nonatomic, weak) id<SCLoginTextFieldCellDelegate> delegate;

@property (nonatomic) SCLoginTextFieldType type;//placehloder + 键盘 和长度
@property (nonatomic, strong) NSString *placehloder;
@property (nonatomic, assign) NSInteger maxTextLength;//default 0, mean not limit

- (UIView *)bodyView;

- (void)hiddenIcon:(BOOL)hidden;
- (void)setleftGap:(CGFloat)leftGap textHeight:(CGFloat)textHeight;

- (void)textDidChange:(UITextField *)textField;

@end

@interface SCLoginPhoneCell : SCLoginTextFieldCell <UITextFieldDelegate>

@property (nonatomic) BOOL phoneTextStyle;
@property (nonatomic, assign) BOOL showListDownArrow;//展开列表的箭头
@property (nonatomic, assign) BOOL isShowList;

+ (NSString *)phoneStyleText:(NSString *)text;

@end

@interface SCLoginPhoneCodeCell : SCLoginPhoneCell

@property (nonatomic, strong) SCCodeBtn *codeBtn;

@end

@interface SCCodeBtn : UIButton

@property (nonatomic) NSInteger time;
@property (nonatomic) NSInteger timeCount;
@property (nonatomic) SCCodeBtnStatus status;

@property (nonatomic, strong) UIColor *normalColor;

- (void)stopTimer;

@end

@interface SCLoginPasswordCell : SCLoginTextFieldCell

@property (nonatomic) BOOL isSecure;

- (void)setSecureStatusBtnRightGap:(CGFloat)rightGap;

@end
