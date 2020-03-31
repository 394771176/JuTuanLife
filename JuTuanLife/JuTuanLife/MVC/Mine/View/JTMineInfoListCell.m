//
//  JTMineInfoListCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineInfoListCell.h"

@interface JTMineInfoListCell () <UITextViewDelegate> {
//    UITextField *_textField;
    UITextView *_textView;
    UIButton *_cameraBtn;
}

@end

@implementation JTMineInfoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.frame = RECT(28, 0, 80, self.contentView.height);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.contentLabel.frame = RECT(self.titleLabel.right + 8, 0, self.contentView.width - self.titleLabel.right - 8 - 92, self.contentView.height);
        self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        
        [self setTitleColorString:@"333333" withFontSize:16];
        [self setContentColorString:@"333333" withFontSize:16];
        
        [self setSeparatorLineWithLeft:self.contentLabel.left andRight:(self.contentView.width - self.contentLabel.right)];
        
        [self setLineStyle:DTCellLineNone];
    }
    return self;
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
//    if (canEdit && !_textField) {
//        UICREATETo(_textField, UITextField, self.contentLabel.left, self.contentLabel.top, self.contentLabel.width, self.contentLabel.height, AAWH, self.contentView);
//        [_textField setTextColor:self.contentLabel.textColor];
//        [_textField setFont:self.contentLabel.font];
//        _textField.text = self.content;
//        _textField.delegate = self;
//    }
//    _textField.hidden = !canEdit;

    if (canEdit && !_textView) {
        UICREATETo(_textView, UITextView, self.contentLabel.left, self.contentLabel.top, self.contentLabel.width, self.contentLabel.height, AAWH, self.contentView);
        [_textView setTextColor:self.contentLabel.textColor];
        [_textView setFont:self.contentLabel.font];
        _textView.text = self.content;
        _textView.delegate = self;
    }
    _textView.hidden = !canEdit;
    
    self.contentLabel.hidden = canEdit;
    
    [self setLineStyle:(_canEdit ? DTCellLineCustom : DTCellLineNone)];
}

- (void)setShowCamera:(BOOL)showCamera
{
    _showCamera = showCamera;
    if (_showCamera && !_cameraBtn) {
        UICREATEBtnTo(_cameraBtn, UIButton, self.contentView.width - 60 - 33, 0, 33, self.contentView.height, AAL|AAH, nil, nil, nil, self, @selector(cameraAction), self.contentView);
        [_cameraBtn setImageWithImageName:@"user_home_camera"];
    }
    _cameraBtn.hidden = !_showCamera;
}

- (void)setContent:(NSString *)content
{
    [super setContent:content];
    if (_canEdit) {
        if (content.length <= 0 || ![_textView.text isEqualToString:content]) {
            _textView.text = content;
        }
    }
}

- (void)cameraAction
{
    NSLog(@"camera");
}

#pragma mark - UITextViewDelegate

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    if (_canEdit) {
//        return NO;
//    }
//    return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.content = textView.text;
    if (_delegate && [_delegate respondsToSelector:@selector(loginTextFieldCell:textFieldDidChange:)]) {
        [_delegate loginTextFieldCell:(id)self textFieldDidChange:(id)_textView];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (self.maxTextLength > 0) {
//        return text.length <= self.maxTextLength;
//    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginTextFieldCell:textFieldDidReturn:)]) {
        [_delegate loginTextFieldCell:(id)self textFieldDidReturn:textField];
    }
    return YES;
}

- (void)textDidChange:(UITextField *)textField
{
    self.content = textField.text;
    if (_delegate && [_delegate respondsToSelector:@selector(loginTextFieldCell:textFieldDidChange:)]) {
        [_delegate loginTextFieldCell:(id)self textFieldDidChange:textField];
    }
}

+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView
{
    if (item) {
        CGFloat height = [item sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.width - 28 - 8 - 92, FLT_MAX)].height;
        
        return MAX(44, height + 24);
    }
    return 44;
}

@end
