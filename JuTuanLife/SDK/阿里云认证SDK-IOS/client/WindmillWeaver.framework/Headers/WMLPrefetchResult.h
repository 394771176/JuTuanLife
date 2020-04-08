//
//  WMLPrefetchResult.h
//  Weaver
//
//  Created by AllenHan on 2019/8/1.
//  Copyright © 2019年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMLPrefetchResult : NSObject

@property (nonatomic, copy) NSString *feature; // 预加载类型
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger status; // 1=完成，2=异常，3=部分完成，4=进行中，0=状态未知
@property (nonatomic, strong) NSDictionary *extra;

@end

NS_ASSUME_NONNULL_END
