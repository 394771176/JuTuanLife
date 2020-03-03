//
//  DTNavigationController.m
//  DrivingTest
//
//  Created by Huang Tao on 1/22/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "DTNavigationController.h"
//#import "BPUINavigationBar.h"
#import "DTViewController.h"
#import "WCUICommon.h"

@interface DTNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation DTNavigationController
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

- (void)setup
{
    //...do something
}

#pragma mark - UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self.viewControllers lastObject] preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [[self.viewControllers lastObject] prefersStatusBarHidden];
}

#pragma mark - NSObject
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [super setDelegate:self];
    
    self.navigationBar.translucent = NO;//当我们translucent设置为NO时，当前vc的view的坐标默认是从导航栏下方开始
//    [self navigationBarAddLine];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (iOS(7)) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (IS_IPHONE) {
        BOOL support = toInterfaceOrientation==UIInterfaceOrientationPortrait;
        return support;
    } else {
        return YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    if (IS_IPHONE) {
        return [WCAppStyleUtil supportedInterfaceOrientations];
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.viewControllers.count<=1) {
        return NO;
    } else {
        if ([(DTViewController *)self.topViewController respondsToSelector:@selector(disableBackGesture)]) {
            if ([(DTViewController *)self.topViewController disableBackGesture] || [self hadInsertViewWithIndex:0]) {
                return NO;
            } else {
                return YES;
            }
        } else {
            return YES;
        }
    }
}

- (BOOL)hadInsertViewWithIndex:(NSInteger)index
{
    NSInteger count = self.view.subviews.count;
    if (index < count - 1) {
        UIView *view = [[self.view subviews] safeObjectAtIndex:count - 1 - index];
        return (![view isKindOfClass:NSClassFromString(@"UINavigationTransitionView")]&&view.isUserInteractionEnabled&&CGRectEqualToRect(view.frame, self.view.bounds));
    }
    return NO;
}

@end
