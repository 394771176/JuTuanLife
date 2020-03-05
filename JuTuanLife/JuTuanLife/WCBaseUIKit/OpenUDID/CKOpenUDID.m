//
//  CKOpenUDID.m
//  KeychainDemo
//
//  Created by 李正兴 on 2017/5/11.
//  Copyright © 2017年 wangpeng. All rights reserved.
//

#import "CKOpenUDID.h"
#import "CKUDIDManager.h"

@implementation CKOpenUDID

+ (NSString *)value
{
    static NSString *openUDID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        openUDID = [CKUDIDManager getOpenUdid];
    });
    return openUDID;
}

@end
