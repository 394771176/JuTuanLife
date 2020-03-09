//
//  JTMineInfoListCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "SCLoginTextFieldCell.h"

@interface JTMineInfoListCell : DTTitleContentCell

@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL showCamera;
@property (nonatomic, weak) id<SCLoginTextFieldCellDelegate> delegate;

@end
