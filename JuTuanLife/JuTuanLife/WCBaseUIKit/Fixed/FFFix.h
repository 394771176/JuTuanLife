//
//  FFFix.h
//  FFStory
//
//  Created by PageZhang on 16/3/3.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DTFix+iOS13.h"

@interface UIView (Fix)
@end

@interface UILabel (Fix)
@end

@interface UITableView (Fix)
@end

@interface UIImageView (Fix)
@end

@interface UITableViewCell (Fix)
@end

@interface UICollectionViewCell (Fix)
@end

@interface UINavigationItem (Fix)

@end

@interface NSDictionary (Fix)
//方法不外放，只做替换修复，外面依然用原来方法
// key对应的value（数据类型安全）
//- (NSString *)ff_stringForKey:(id)aKey;
//- (NSInteger)ff_integerForKey:(id)aKey;
//- (float)ff_floatForKey:(id)aKey;
//- (double)ff_doubleForKey:(id)aKey;
//- (BOOL)ff_boolForKey:(id)aKey;

@end

@interface NSArray (Fix)

@end

@interface NSObject (Fix)

@end

@interface NSTimer (Fix)

@end
