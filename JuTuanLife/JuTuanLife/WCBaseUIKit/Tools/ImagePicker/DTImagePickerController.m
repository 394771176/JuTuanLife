//
//  DTImagePickerController.m
//  DrivingTest
//
//  Created by kent on 15/1/27.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import "DTImagePickerController.h"
#import "WCUICommon.h"

@interface DTImagePickerController ()

@end

@implementation DTImagePickerController

+ (void)showInViewController:(UIViewController<UIImagePickerControllerDelegate> *)vc
                  sourceType:(UIImagePickerControllerSourceType)sourceType
{
    [self showInViewController:vc sourceType:sourceType config:nil];
}

+ (void)showInViewController:(UIViewController<UIImagePickerControllerDelegate> *)vc
                  sourceType:(UIImagePickerControllerSourceType)sourceType
                      config:(void (^)(DTImagePickerController *))config
{
//    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
//        if (![FFConfiguration accessEnable:FFAccessType_CAMERA]) {
//            [FFConfiguration accessPrompt:FFAccessType_CAMERA];
//            return;
//        }
//    } else {
//        if (![FFConfiguration accessEnable:FFAccessType_PHOTOS]) {
//            [FFConfiguration accessPrompt:FFAccessType_PHOTOS];
//            return;
//        }
//    }
    
    FFAccessType type = FFAccessType_PHOTOS;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        type = FFAccessType_CAMERA;
    }
    [FFConfiguration accessEnable:type handler:^{
        DTImagePickerController *imagePicker = [[DTImagePickerController alloc] init];
        imagePicker.sourceType = sourceType;
        imagePicker.delegate = (id)vc;
        if (config) {
            config(imagePicker);
        }
        [vc presentViewController:imagePicker animated:YES completion:NULL];
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.navigationBar.translucent = NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [WCAppStyleUtil statusBarStyle];
}

@end
