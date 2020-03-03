//
//  VGEDataModel-Private.h
//  VGEUI
//
//  Created by Hunter Huang on 8/14/11.
//  Copyright 2011 Hunter Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDataResult.h"
#import "VGEDataModel.h"

@interface VGEDataModel()

@property (nonatomic, strong) id data;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSDate *lastUpdatedTime;
@property (nonatomic, strong) WCDataResult *result;

- (void)notifyDelegateWithMethod:(SEL)method;

@end
