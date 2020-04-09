//
//  WCLinkUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCLinkUtil : NSObject

+ (DTWebViewController *)getWebControllerWith:(NSString *)link;
+ (UIViewController *)getNativeControllerWith:(NSString *)link;

+ (UIViewController *)getControllerWithLink:(NSString *)link;
+ (UIViewController *)getControllerWithLink:(NSString *)link forcePush:(BOOL)forcePush;

//是否允许打开链接，如
+ (BOOL)shouldOpenLink:(NSString *)link;

+ (BOOL)openWithLink:(NSString *)link;
+ (BOOL)openWithLink:(NSString *)link popOne:(BOOL)popOne;

+ (void)checkOpenController:(UIViewController *)controller withLink:(NSString *)link popOne:(BOOL)popOne;

+ (BOOL)handleOpenURL:(NSURL *)url;

@end

@interface DTLinkBlankController : UIViewController

@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) DTCommonBlock block;
@property (nonatomic, strong) DTIntBlock intBlock;

+ (DTLinkBlankController *)controller;
+ (DTLinkBlankController *)controllerWithBlock:(DTCommonBlock)block;
+ (DTLinkBlankController *)controllerWithBlock:(DTCommonBlock)block userInfo:(id)userInfo;

+ (DTLinkBlankController *)controllerWithBlock:(DTIntBlock)block index:(NSInteger)index;

//提示升级app
+ (DTLinkBlankController *)controllerForUpgradeApp;

- (void)didBlock;

@end
