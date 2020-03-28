//
//  JTBusinessFenRunItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCModel.h>

@interface JTBusinessFenRunTitleItem : WCBaseEntity

/*dateFrom    string
 日期范围开始
 
 dateTo    string
 日期范围结束
 
 explanation    string
 说明文字
 
 lastPos    string
 分页位置标记
 
 performanceDetails    [
 业绩数据列表
 
 BusinessPerformanceDetailDTO{
 values    [
 业绩数据列值，暂固定4列
 
 string]
 }]
 performanceTitles    [
 业绩数据列标题，暂固定4列
 
 string]
 */
@property (nonatomic, strong) NSString *dateFrom;
@property (nonatomic, strong) NSString *dateTo;
@property (nonatomic, strong) NSString *explanation;
@property (nonatomic, strong) NSArray *performanceTitles;

- (NSString *)dateStr;

@end

@interface JTBusinessFenRunItem : WCBaseEntity

@property (nonatomic, strong) NSArray *values;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat total;
@property (nonatomic, assign) CGFloat fenrunMon;
@property (nonatomic, strong) NSString *date;

@end
