//
//  DTMainTabBarView.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTabBarView.h"


@interface DTMainTabBarView : DTTabBarView

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *selImages;

- (void)setImages:(NSArray *)images selImages:(NSArray *)selImages;

@end
