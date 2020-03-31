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
    UITextView *_textView;
    UILabel *_wordLabel;
    
    UILabel *_tipsLabel;
}

@end

@implementation DTTextViewEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 2, self.contentView.width-16, self.contentView.height-30)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.text = _orignalText;
        [_textView becomeFirstResponder];
        [self.contentView addSubview:_textView];
        
        _wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _textView.bottom+5, self.contentView.width-16, 15)];
        _wordLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _wordLabel.backgroundColor = [UIColor clearColor];
        _wordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _wordLabel.font = [UIFont systemFontOfSize:13];
        _wordLabel.textAlignment = NSTextAlignmentRight;
        _wordLabel.textColor = [UIColor colorWithHexString:@"acacac" alpha:1];
        [self.contentView addSubview:_wordLabel];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, self.contentView.width-8, self.contentView.height)];
        _tipsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"acacac" alpha:1];
        _tipsLabel.text = self.tips;
        [self.contentView addSubview:_tipsLabel];
    }
    return self;
}


@end
