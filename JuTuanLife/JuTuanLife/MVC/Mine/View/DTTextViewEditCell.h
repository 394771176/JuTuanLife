//
//  DTTextViewEditCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/1.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTTextViewEditCell : DTTableCustomCell

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *orignalText;

@property (nonatomic, readonly) NSString *text;

//@property (nonatomic, strong) NSString *tips;
//
//@property (nonatomic) int textCount;

@end
