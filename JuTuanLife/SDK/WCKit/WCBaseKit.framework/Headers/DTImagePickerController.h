//
//  DTImagePickerController.h
//  DrivingTest
//
//  Created by kent on 15/1/27.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTImagePickerController : UIImagePickerController

+ (void)showInViewController:(UIViewController<UIImagePickerControllerDelegate> *)vc
                  sourceType:(UIImagePickerControllerSourceType)sourceType;

+ (void)showInViewController:(UIViewController<UIImagePickerControllerDelegate> *)vc
                  sourceType:(UIImagePickerControllerSourceType)sourceType
                      config:(void (^)(DTImagePickerController *picker))config;

@end
