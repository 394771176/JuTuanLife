//
//  DTFix+iOS13.h
//  DrivingTest
//
//  Created by cheng on 2020/1/6.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DTFix_iOS13 : NSObject

@end

@interface UIViewController (DT_iOS13)

//default is NO, 不允许用pageSheet形式跳转
@property (nonatomic, assign) BOOL allowModalPresentationPageSheet;

@end

@interface UIApplication (DT_iOS13)

@end

@interface UISearchBar (DT_iOS13)

- (UITextField *)searchField;

- (void)setSearchFieldPlaceholderFont:(UIFont *)font;
- (void)setSearchFieldPlaceholderColor:(UIColor *)color;

@end

