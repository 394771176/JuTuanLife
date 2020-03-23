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

+ (void)addBlock:(void (^)(void))block withDelay:(CGFloat)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

+ (void)addBlockOnBackgroundThread:(void (^)(void))block
{
    [self performSelectorInBackground:@selector(runBlockInBackground:) withObject:block];
}

+ (void)runBlockInBackground:(void (^)(void))block
{
    @autoreleasepool {
        block();
    }
}

+ (void)callPhoneNumber:(NSString *)phone
{
    if (phone.length<=0) {
        [self showHUDErrorHintInWindow:@"电话号码不能为空"];
        return;
    }
    //telprompt:
    //NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"telprompt:%@",phone]];
    NSString *strDeviceType = [UIDevice currentDevice].model;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]];
    BOOL canMakeCall = YES;
    if ([strDeviceType isEqualToString:@"iPod touch"] || [strDeviceType isEqualToString:@"iPad"] || [strDeviceType isEqualToString:@"iPhone Simulator"]) {
        canMakeCall = NO;
    }
    if (canMakeCall && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [self showHUDErrorHintInWindow:@"该设备不支持拨号服务"];
    }
}

@end
