//
//  BPAppPreference.h
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 替代NSUserDefaults，用于保存app中需要用到的简单的设置。
 */
@interface BPAppPreference : NSObject

@property (nonatomic, assign) BOOL delaySyn DEPRECATED_ATTRIBUTE; // 目前存储后会在后台线程进行文件保存

+ (BPAppPreference *)sharedInstance;
- (id)initWithFilePath:(NSString *)path;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (BOOL)containsObjectForKey:(NSString *)key;
- (NSArray *)allKeys;

- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;

@end
