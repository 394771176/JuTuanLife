//
//  BPAppPreference.m
//  VGEUtil
//
//  Created by Hunter Huang on 8/13/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import "BPAppPreference.h"
#import "BPFileUtil.h"
#import <WCCategory/WCCategory.h>

@interface BPAppPreference() {
    dispatch_queue_t _syncQueue;
    dispatch_queue_t _syncDataToFileQueue;
}

@property (nonatomic, retain) NSMutableDictionary *mutableDict;
@property (nonatomic, retain) NSString *filePath;

@end

@implementation BPAppPreference

@synthesize mutableDict, filePath;

- (id)init {
    self = [super init];
    if (self) {
        _syncQueue = dispatch_queue_create("wc.appPreference.plist.queue", DISPATCH_QUEUE_SERIAL);
        _syncDataToFileQueue = dispatch_queue_create("wc.appPreference.plist.data.queue", DISPATCH_QUEUE_SERIAL);
        self.filePath = [BPFileUtil getDocumentPathWithDir:@"appPreference" fileName:@"appPreference.plist"];
        
        dispatch_async(_syncQueue, ^{
            self.mutableDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            if (!mutableDict) {
                self.mutableDict = [NSMutableDictionary dictionary];
            }
        });
    }
    return self;
}

- (id)initWithFilePath:(NSString *)path {
    self = [super init];
    if (self) {
        NSString *queueName = [NSString stringWithFormat:@"com.eclicks.%@.queue", path.lastPathComponent];
        NSString *dataQueueName = [NSString stringWithFormat:@"com.eclicks.%@.data.queue", path.lastPathComponent];
        _syncQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
        _syncDataToFileQueue = dispatch_queue_create(dataQueueName.UTF8String, DISPATCH_QUEUE_SERIAL);
        self.filePath = path;
        
        dispatch_async(_syncQueue, ^{
            self.mutableDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            if (!mutableDict) {
                self.mutableDict = [NSMutableDictionary dictionary];
            }
        });
    }
    return self;
}

+ (BPAppPreference *)sharedInstance {
    static BPAppPreference *instance = nil;
    if (!instance) {
        instance = [[BPAppPreference alloc] init];
    }
    return instance;
}

- (void)saveData:(NSDictionary *)dict
{
    @autoreleasepool {
        @try {
            [dict writeToFile:filePath atomically:YES];
        } @catch (NSException *exception) {
            //nothing to do
        }
    }
}

///////////////////////////////
- (void)setObject:(id)value forKey:(NSString *)key {
    dispatch_async(_syncQueue, ^{
        [mutableDict safeSetObject:value forKey:key];
        NSDictionary *dict = [mutableDict copy];
        dispatch_async(_syncDataToFileQueue, ^{
            [self saveData:dict];
        });
    });
}

- (id)objectForKey:(NSString *)key {
    __block id object = nil;
    dispatch_sync(_syncQueue, ^{
        object = [mutableDict objectForKey:key];
    });
    return object;
}

- (void)removeObjectForKey:(NSString *)key {
    dispatch_async(_syncQueue, ^{
        [mutableDict removeObjectForKey:key];
        NSDictionary *dict = [mutableDict copy];
        dispatch_async(_syncDataToFileQueue, ^{
            [self saveData:dict];
        });
    });
}

- (BOOL)containsObjectForKey:(NSString *)key
{
    __block BOOL isContains = NO;
    dispatch_sync(_syncQueue, ^{
        isContains = [[mutableDict allKeys] containsObject:key];
    });
    return isContains;
}

- (NSArray *)allKeys
{
    __block NSArray *keys = nil;
    dispatch_sync(_syncQueue, ^{
        keys = [mutableDict allKeys];;
    });
    return keys;
}

///////////////////////////////
- (NSString *)stringForKey:(NSString *)key {
    __block NSString *string = nil;
    dispatch_sync(_syncQueue, ^{
        string = [mutableDict stringForKey:key];
    });
    return string;
}

- (NSArray *)arrayForKey:(NSString *)key {
    __block NSArray *array = nil;
    dispatch_sync(_syncQueue, ^{
        array = [mutableDict arrayForKey:key];
    });
    return array;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    __block NSDictionary *dict = nil;
    dispatch_sync(_syncQueue, ^{
        dict = [mutableDict dictionaryForKey:key];
    });
    return dict;
}

- (NSData *)dataForKey:(NSString *)key {
    __block NSData *data = nil;
    dispatch_sync(_syncQueue, ^{
        data = [mutableDict objectForKey:key];
    });
    return data;
}

- (NSInteger)integerForKey:(NSString *)key {
    __block NSInteger value = 0;
    dispatch_sync(_syncQueue, ^{
        value = [mutableDict integerForKey:key];
    });
    return value;
}

- (float)floatForKey:(NSString *)key {
    __block float value = 0;
    dispatch_sync(_syncQueue, ^{
        value = [mutableDict floatForKey:key];
    });
    return value;
}

- (double)doubleForKey:(NSString *)key {
    __block double value = 0;
    dispatch_sync(_syncQueue, ^{
        value = [mutableDict doubleForKey:key];
    });
    return value;
}

- (BOOL)boolForKey:(NSString *)key {
    __block BOOL value = 0;
    dispatch_sync(_syncQueue, ^{
        value = [mutableDict boolForKey:key];
    });
    return value;
}

///////////////////////////////
- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

@end
