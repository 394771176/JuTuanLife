//
//  JTShipAddCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/19.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTShipAddCell : DTTableCustomCell

@property (nonatomic, weak) id<DTTableButtonCellDelegate> delegate;

@property (nonatomic, strong) JTUser *item;

@end

NS_ASSUME_NONNULL_END
