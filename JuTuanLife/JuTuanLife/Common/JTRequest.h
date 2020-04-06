//
//  JTRequest.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCNetKit/WCNetManager.h>
#import "JTDataResult.h"

typedef NS_ENUM(NSUInteger, JTServerType) {
    JTServerType1,
    JTServerType2,
    JTServerType3
};

@interface JTRequest : WCDataRequest

@property (nonatomic, assign) JTServerType serverType;
@property (nonatomic, assign) BOOL ignoreCheckToken;

+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params;
+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;
+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod serverType:(JTServerType)serverType;

+ (id)uploadImage:(UIImage *)image;

+ (NSMutableDictionary *)paramsWithPos:(NSString *)pos pageSize:(NSInteger)pageSize;

@end
