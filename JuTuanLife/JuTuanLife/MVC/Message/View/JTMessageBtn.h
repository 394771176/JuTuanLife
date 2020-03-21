//
//  JTMessageBtn.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTMessageBtn : UIButton

@property (nonatomic, assign) NSInteger badge;

- (void)updateMessageCount;

@end
