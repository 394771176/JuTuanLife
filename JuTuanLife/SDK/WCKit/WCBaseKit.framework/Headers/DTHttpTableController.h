//
//  DTHttpTableController.h
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTTableController.h"
#import <WCModel/WCModel.h>

@interface DTHttpTableController : DTTableController <VGEDataModelDelegate> {

}

@property (nonatomic, strong) DTListDataModel *dataModel;
@property (nonatomic) BOOL disableNoDataView;
@property (nonatomic, readonly) BOOL refreshOneTimeWhenAppear;
@property (nonatomic) BOOL isDataModelLoadedFromNet;

@property (nonatomic) BOOL reloadForCache;//defaule is yes
@property (nonatomic) BOOL autoRefresh;//defaule is yes
@property (nonatomic, assign) BOOL autoCreateModel;//default is yes

//当页面有缓存时，通过该属性 决定是否展示错误信息
@property (nonatomic, assign) BOOL needShowModelError;

- (DTListDataModel *)createDataModel;
- (id)Model;

- (void)refresh;
- (void)reloadData;
- (void)enableRefreshOneTimeWhenAppear;
- (BOOL)haveCacheOrData;

- (void)resetDataModel:(DTListDataModel *)dataModel;

@end
