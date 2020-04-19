//
//  JTLoadingView.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTLoadingView : UIView <WCBaseUILoadingIndicatorProtocol>

@property (nonatomic, assign) CGFloat minDuration;

@end
