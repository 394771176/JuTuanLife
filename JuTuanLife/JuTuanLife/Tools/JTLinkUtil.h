//
//  JTLinkUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTLinkUtil : NSObject

+ (DTViewController *)getControllerWithLink:(NSString *)link;

+ (void)openLink:(NSString *)link;

+ (BOOL)handleOpenURL:(NSURL *)url;

@end
