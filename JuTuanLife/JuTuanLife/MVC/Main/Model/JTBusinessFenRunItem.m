//
//  JTBusinessFenRunItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBusinessFenRunItem.h"

@implementation JTBusinessFenRunTitleItem

- (NSString *)dateStr
{
    if (self.dateFrom && self.dateTo) {
        if (![self.dateFrom isEqualToString:self.dateTo]) {
            return [NSString stringWithFormat:@"%@ - %@", self.dateFrom, self.dateTo];
        }
    }
    
    return [NSString stringWithFormat:@"%@ - %@", self.dateFrom, self.dateTo];
}

@end

@implementation JTBusinessFenRunItem

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    self.title = [_values safeObjectAtIndex:0];
    
    self.total = [[_values safeObjectAtIndex:1] floatValue];
    self.fenrunMon = [[_values safeObjectAtIndex:2] floatValue];
    
    self.date = [_values safeObjectAtIndex:3];
    
    return YES;
}

@end
