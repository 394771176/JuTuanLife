//
//  CWKeyboardNotifition.h
//  ChelunWelfare
//
//  Created by cheng on 15/1/24.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class CWKeyboardManager;

@protocol CWKeyboardNotifitionDelegate <NSObject>

- (void)keyboardWillShow:(CWKeyboardManager *)keyboardManager;
- (void)keyboardWillHide:(CWKeyboardManager *)keyboardManager;

@end

@interface CWKeyboardManager : NSObject

@property (nonatomic, weak) id<CWKeyboardNotifitionDelegate> delegate;
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) BOOL keyboardVesible;

- (id)initWithDelegate:(id<CWKeyboardNotifitionDelegate>)delegate;
- (void)viewWillAppear;
- (void)viewWillDisappear;

+ (instancetype)sharedInstance;
- (void)setUp;

@end

