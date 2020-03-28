//
//  JTMessageItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCModel.h>

@interface JTMessageItem : WCBaseEntity

/*
 "messages": [
 {
 "content": "string",
 "contentType": "string",
 "createTime": "2020-03-21T17:28:24.212Z",
 "id": "string",
 "msgType": "string",
 "title": "string"
 }
 */
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *msgType;

@property (nonatomic, strong) NSString *createTime;

@end
