//
//  WCBaseManager.h
//  WCBaseKit
//
//  Created by cheng on 2020/4/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

@end
