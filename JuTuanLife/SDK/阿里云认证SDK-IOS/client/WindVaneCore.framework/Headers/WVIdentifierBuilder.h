//
//  WVIdentifierBuilder.h
//  WindVane
//
//  Created by 郑祯 on 2019/8/5.
//

#import <Foundation/Foundation.h>

/**
 webView 的标识符生成器。
 */
@interface WVIdentifierBuilder : NSObject

/**
 webView 标识。
 */
+ (NSString * _Nullable)webViewIdentifier;

@end
