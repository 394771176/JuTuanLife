//
//  WCPubUtil.h
//  Pods
//
//  Created by cheng on 2019/10/16.
//

#import <Foundation/Foundation.h>

@interface DTPubUtil : NSObject

#pragma mark - Device

+ (BOOL)isIPhoneX;

#pragma mark - HUD

// MARK: - loading时 HUD 需要手动stop
+ (void)startHUDLoading:(NSString *)text;
+ (void)startHUDLoading:(NSString *)text addTo:(UIView *)view;
+ (void)stopHUDLoading;
+ (void)stopHUDLoading:(NSTimeInterval)delay;
+ (void)stopHUDLoadingFromView:(UIView *)view;

+ (void)showHUDMessageInWindow:(NSString *)msg;
+ (void)showHUDMessageInWindow:(NSString *)msg textOffset:(CGFloat)offset;
+ (void)showHUDErrorHintInWindow:(NSString *)msg;
+ (void)showHUDSuccessHintInWindow:(NSString *)msg;
+ (void)showHUDNoNetWorkHintInWindow;
+ (void)showHUDInWindowWithImage:(NSString *)imageName andMessage:(NSString *)msg;

+ (void)sendTagert:(id)tagert action:(SEL)action object:(id)object;
+ (void)sendTagert:(id)tagert action:(SEL)action object:(id)object object2:(id)object2;

@end
