//
//  JTLoadingView.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoadingView.h"
#import <WCBaseKit/WCBaseKit.h>

@interface JTLoadingView () {
    NSTimeInterval _beginTime;
}

@end


@implementation JTLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minDuration = 0.5;
    }
    return self;
}

- (void)start
{
    _beginTime = CACurrentMediaTime();
    [DTPubUtil startHUDLoading:@"加载中"];
}

- (void)stop
{
    NSTimeInterval time = CACurrentMediaTime() - _beginTime;
    if (time < _minDuration) {
        [DTPubUtil addBlock:^{
            [DTPubUtil stopHUDLoading];
        } withDelay:_minDuration-time];
    } else {
        [DTPubUtil stopHUDLoading];
    }
    
}

@end
