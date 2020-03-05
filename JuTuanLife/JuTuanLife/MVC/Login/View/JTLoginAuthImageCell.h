//
//  JTLoginAuthImageCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTLoginAuthImageCell : DTTableCustomCell

@property (nonatomic, assign) NSInteger step;
@property (nonatomic, weak) id<DTTableButtonCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
