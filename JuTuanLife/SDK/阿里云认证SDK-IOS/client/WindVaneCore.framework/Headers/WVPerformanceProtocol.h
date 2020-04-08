//
//  WVTriverPerformanceProtocol.h
//  WindVane
//
//  Created by 郑祯 on 2019/8/22.
//

#import <Foundation/Foundation.h>

/**
 * Triver 的性能协议。
 */
@protocol WVPerformanceProtocol <NSObject>

#pragma mark - Process

- (void)start;
- (void)end;

#pragma mark - Data

- (void)recordStage:(NSString * _Nonnull)stage timestamp:(double)timestamp;
- (void)recordStatistics:(NSDictionary * _Nonnull)statistics;
- (void)recordProperties:(NSDictionary * _Nonnull)properties;

@end
