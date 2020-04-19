//
//  DTListDataModel.h
//  DrivingTest
//
//  Created by Hunter Huang on 3/14/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import "VGEListDataModel.h"
#import "WCDataResult.h"
#import "BPCacheManager.h"

/**
 列表数据加载model，支持缓存
 */
@interface DTListDataModel : VGEListDataModel

@property (nonatomic, readonly) NSString *cacheKey;
@property (nonatomic, readonly) NSInteger cacheDuration;
@property (nonatomic, readonly) NSString *trait;
@property (nonatomic, assign) BOOL hasLoadData;//是否请求过数据
@property (nonatomic, assign) BOOL isLoadCache;//是否在加载缓存，parseData 方法 可根据该值做不同事情

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, strong) id userInfo;//扩展信息

- (void)setup;

- (void)loadCache;
- (void)saveCache:(WCDataResult *)result;

- (WCDataResult *)cacheResult:(WCDataResult *)result;

- (void)moveObjectfromIndex:(NSInteger)indexF to:(NSInteger)indexT;
- (void)deleteObjectFromIndex:(NSInteger)index;

- (NSInteger)autoReloadMinDuration;//单位 秒，默认五分钟 5 * 60；

- (void)resetReloadStatus;

- (void)reloadDelay:(CGFloat)delay;
- (BOOL)reloadWhenNeed;//默认五分钟 刷新
- (void)loadCache:(void (^)(DTListDataModel *model))block;
- (void)reloadWithLoadCache:(void (^)(DTListDataModel *model))block;

- (void)loadCache:(void (^)(DTListDataModel *model))block andAnotherModel:(DTListDataModel *)model;

- (WCDataResult *)syncReloadData;

//+ (NSString *)getSessionUserTrait;

@end
