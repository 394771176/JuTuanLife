//
//  DTListDataModel.m
//  DrivingTest
//
//  Created by Hunter Huang on 3/14/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import "DTListDataModel.h"
#import "BPCacheManager.h"
#import <WCCategory/WCCategory.h>

@interface DTListDataModel () {
    NSTimeInterval _lastReloadTime;
}

@end

@implementation DTListDataModel

@dynamic cacheKey;
@dynamic cacheDuration;
@dynamic trait;

- (id)initWithDelegate:(id<VGEDataModelDelegate>)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
}

- (NSString *)cacheKey
{
    return nil;
}

- (NSString *)trait
{
    return nil;
}

- (NSInteger)cacheDuration
{
    return 15*24*60*60;
}

- (NSInteger)autoReloadMinDuration
{
    return 5 * 60;
}

- (void)loadCache
{
    if (self.cacheKey) {
        WCDataResult *result = [[BPCacheManager sharedInstance] cacheForKey:self.cacheKey];
        if (result) {
            self.isLoadCache = YES;
            [self setValue:result forKey:@"_result"];
            [self setValue:[self filterData:[self parseData:result.data]] forKey:@"_data"];
            self.isLoadCache = NO;
        }
    }
}

- (id)defaultData
{
    //刷新失败，返回原数据
    return self.data;
}

- (void)resetReloadStatus
{
    //    self.isReload = YES;
    //    self.startIndex = 0;
    // 有 @synthesize 属性，不能加 下划线 _
    [self setValue:[NSNumber numberWithInt:1] forKey:@"isReload"];
    [self setValue:[NSNumber numberWithInt:0] forKey:@"startIndex"];
    
    self.pageNumber = 1;
    self.hasLoadData = YES;
}

- (void)reload
{
    [self resetReloadStatus];
    [super reload];
}

- (BOOL)reloadWhenNeed
{
    NSTimeInterval nowTime = CFAbsoluteTimeGetCurrent();
    if (nowTime - _lastReloadTime > [self autoReloadMinDuration]) {
        [self reload];
        return YES;
    }
    return NO;
}

- (void)reloadDelay:(CGFloat)delay
{
    [self performSelector:@selector(reload) withObject:nil afterDelay:delay];
}

- (WCDataResult *)syncReloadData
{
    [self resetReloadStatus];
    return [self loadData];
}

- (void)loadCache:(void (^)(DTListDataModel *))block
{
//    [DTPubUtil addBlockOnBackgroundThread:^{
//        [self loadCache];
//        [DTPubUtil addBlockOnMainThread:^{
//            if (block) {
//                block(self);
//            }
//        }];
//    }];
}

- (void)reloadWithLoadCache:(void (^)(DTListDataModel *))block
{
    [self loadCache:^(DTListDataModel *model) {
        if (block) {
            block(model);
        }
        [model reload];
    }];
}

- (void)loadCache:(void (^)(DTListDataModel *model))block andAnotherModel:(DTListDataModel *)model
{
//    [DTPubUtil addBlockOnBackgroundThread:^{
//        [self loadCache];
//        [model loadCache];
//        [DTPubUtil addBlockOnMainThread:^{
//            if (block) {
//                block(self);
//            }
//        }];
//    }];
}

- (void)willFinishLoadOnMainThread
{
    _lastReloadTime = CFAbsoluteTimeGetCurrent();
    self.pageNumber ++;
    [super willFinishLoadOnMainThread];
}

- (void)saveCache:(WCDataResult *)result
{
    if (result.success && self.cacheKey) {
        if (self.cacheDuration>0) {
            [[BPCacheManager sharedInstance] setCache:result forKey:self.cacheKey trait:self.trait duration:self.cacheDuration];
        } else {
            [[BPCacheManager sharedInstance] setCache:result forKey:self.cacheKey trait:self.trait];
        }
    }
}

- (WCDataResult *)cacheResult:(WCDataResult *)result
{
    if (self.cacheKey && self.isReload) {
        if (result.success) {
            [self saveCache:result];
        }
    }
    return result;
}

- (BOOL)testCanLoadMoreWithNewResult:(NSArray *)newResult
{
    BOOL canLoadMore = [super testCanLoadMoreWithNewResult:newResult];
    NSDictionary *dict = self.result.data;
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict allKeys] containsObject:@"total"] && [[dict allKeys] containsObject:@"rows"] && [[dict objectForKey:@"rows"] isKindOfClass:[NSArray class]]) {
            NSInteger total = [dict integerForKey:@"total"];
            return self.itemCount + newResult.count < total;
        } else if ([[dict allKeys] containsObject:@"last_page"]) {
            //兼容超级教练接口返回值 --owen
            BOOL lastPage = [dict boolForKey:@"last_page"];
            return !lastPage;
        }
    }
    return canLoadMore;
}

- (void)moveObjectfromIndex:(NSInteger)indexF to:(NSInteger)indexT
{
    if (self.data) {
        [self.data moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:indexF] toIndex:indexT];
    }
}

- (void)deleteObjectFromIndex:(NSInteger)index
{
    if (self.data) {
        if (index < [self.data count]) {
            [self.data removeObjectAtIndex:index];
        }
    }
}

@end
