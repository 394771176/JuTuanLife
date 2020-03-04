//
//  WCPubUtil.m
//  Pods
//
//  Created by cheng on 2019/10/16.
//

#import "DTPubUtil.h"
#import "WCUICommon.h"

@implementation DTPubUtil

#pragma mark - Device

+ (BOOL)isIPhoneX
{
    return IS_iPhoneX;
}

#pragma mark - HUD

+ (void)startHUDLoading:(NSString *)text
{
    [self startHUDLoading:text addTo:[WCControllerUtil appWindow]];
}

+ (void)startHUDLoading:(NSString *)text addTo:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    loadingHud.detailsLabelText = text;
    loadingHud.removeFromSuperViewOnHide = YES;
    loadingHud.detailsLabelFont = [UIFont systemFontOfSize:16.f];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
}

+ (void)stopHUDLoading
{
    [self stopHUDLoading:0.f];
}

+ (void)stopHUDLoading:(NSTimeInterval)delay
{
    [MBProgressHUD stopLoadingHUD:delay];
}

+ (void)stopHUDLoadingFromView:(UIView *)view
{
    [MBProgressHUD stopHUDLoadingFormView:view];
}

+ (void)showHUDMessageInWindow:(NSString *)msg
{
    [MBProgressHUD showHUDMessageInWindow:msg];
}

+ (void)showHUDMessageInWindow:(NSString *)msg textOffset:(CGFloat)offset
{
    [MBProgressHUD showHUDMessageInWindow:msg textOffset:offset];
}

+ (void)showHUDErrorHintInWindow:(NSString *)msg
{
    [MBProgressHUD showHUDErrorHintInWindow:msg];
}

+ (void)showHUDSuccessHintInWindow:(NSString *)msg
{
    [MBProgressHUD showHUDSuccessHintInWindow:msg];
}

+ (void)showHUDNoNetWorkHintInWindow;
{
    [MBProgressHUD showHUDNoNetworkHintInWindow:@"网络异常"];
}

+ (void)showHUDInWindowWithImage:(NSString *)imageName andMessage:(NSString *)msg
{
    [MBProgressHUD showHUDInWindowWithImage:imageName andMessage:msg];
}

+ (void)sendTagert:(id)tagert action:(SEL)action object:(id)object
{
    if (tagert && action && [tagert respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [tagert performSelector:action withObject:object];
#pragma clang diagnostic pop
    }
}

+ (void)sendTagert:(id)tagert action:(SEL)action object:(id)object object2:(id)object2
{
    if (tagert && action && [tagert respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [tagert performSelector:action withObject:object withObject:object2];
#pragma clang diagnostic pop
    }
}

@end
