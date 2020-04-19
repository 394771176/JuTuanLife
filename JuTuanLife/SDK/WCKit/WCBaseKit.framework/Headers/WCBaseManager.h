//
//  WCBaseManager.h
//  WCBaseKit
//
//  Created by cheng on 2020/4/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCBaseUtil.h"
#import "DTViewController.h"
#import "DTTableController.h"
#import "DTHttpTableController.h"
#import "DTHttpRefreshTableController.h"
#import "DTHttpLoadMoreTableController.h"
#import "DTHttpRefreshLoadMoreTableController.h"
#import "WCBaseUIProtocol.h"

@protocol WCBaseManagerProtocol <NSObject>

@required

@optional

- (NSArray *)domainWhiteList;
- (NSDictionary *)appInsertCookiesList;

- (UIImage *)defaultNoDataImage;
- (UIImage *)defaultCellArrow;

- (UIImage *)defaultControllerBackImg;
- (UIImage *)defaultControllerCloseImg;

- (UIImage *)defaultWebBackImg;
- (UIImage *)defaultWebCloseImg;

//- (BOOL)checkWebViewScheme:(NSString *)urlStr;
//- (BOOL)checkAppLinkScheme:(NSString *)urlStr;

- (id<WCBaseUIRefreshHeaderViewProtocol>)getRefreshHeaderView:(DTHttpRefreshTableController *)controller;

- (id<WCBaseUILoadingIndicatorProtocol>)getLoadingIndicator:(DTViewController *)controller;

@end

@interface WCBaseManager : NSObject

+ (void)setupManager:(id<WCBaseManagerProtocol>)manager;

+ (NSArray *)domainWhiteList;
+ (NSDictionary *)appInsertCookiesList;

+ (UIImage *)defaultNoDataImage;
+ (UIImage *)defaultCellArrow;

+ (UIImage *)defaultControllerBackImg;
+ (UIImage *)defaultControllerCloseImg;

+ (UIImage *)defaultWebBackImg;
+ (UIImage *)defaultWebCloseImg;

+ (id<WCBaseUIRefreshHeaderViewProtocol>)getRefreshHeaderView:(DTHttpRefreshTableController *)controller;

+ (id<WCBaseUILoadingIndicatorProtocol>)getLoadingIndicator:(DTViewController *)controller;

//+ (BOOL)checkWebViewScheme:(NSString *)urlStr;
//+ (BOOL)checkAppLinkScheme:(NSString *)urlStr;

@end
