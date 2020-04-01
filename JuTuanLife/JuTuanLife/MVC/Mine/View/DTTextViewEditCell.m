//
//  DTTextViewEditCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/1.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTextViewEditCell.h"

@interface DTTextViewEditCell ()
<UITextViewDelegate>
{
    UIImageView *_bodyView;
    UITextView *_textView;
    UILabel *_placeholderLabel;
    UILabel *_wordLabel;
    
    UILabel *_tipsLabel;
}

@end

@implementation DTTextViewEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //24 * 24, 6 7 8 7
        UIImage *image = [[UIImage imageNamed:@"login_auth_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 11, 11)];
        UICREATEImageTo(_bodyView, UIImageView, 9, 0, self.contentView.width - 18, self.contentView.height, AAWH, CCFill, image, self.contentView);
        _bodyView.userInteractionEnabled = YES;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, _bodyView.width-20, _bodyView.height-20)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor colorWithString:@"333333"];
        _textView.returnKeyType = UIReturnKeyDone;
        [_textView becomeFirstResponder];
        [_bodyView addSubview:_textView];
        
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 6, _textView.width - 10, 20)];
        _placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.textColor = [UIColor colorWithHexString:@"acacac" alpha:1];
        [_textView addSubview:_placeholderLabel];
        
//        _wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _textView.bottom+5, cell.width-16, 15)];
//        _wordLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//        _wordLabel.backgroundColor = [UIColor clearColor];
//        _wordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        _wordLabel.font = [UIFont systemFontOfSize:13];
//        _wordLabel.textAlignment = NSTextAlignmentRight;
//        _wordLabel.textColor = [UIColor colorWithHexString:@"acacac" alpha:1];
//        [cell addSubview:_wordLabel];
        
//        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, self.contentView.width-8, self.contentView.height)];
//        _tipsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _tipsLabel.backgroundColor = [UIColor clearColor];
//        _tipsLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//        _tipsLabel.font = [UIFont systemFontOfSize:12];
//        _tipsLabel.textColor = [UIColor colorWithHexString:@"acacac" alpha:1];
//        _tipsLabel.text = self.tips;
//        [self.contentView addSubview:_tipsLabel];
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

- (void)setOrignalText:(NSString *)orignalText
{
    _orignalText = orignalText;
    _textView.text = orignalText;
    [self textViewDidChange:_textView];
}

- (NSString *)text
{
    return _textView.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _placeholderLabel.hidden = textView.text.length > 0;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 200;
}

@end
