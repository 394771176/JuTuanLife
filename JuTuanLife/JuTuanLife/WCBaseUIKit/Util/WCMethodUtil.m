//
//  WCMethodUtil.m
//  Pods-WCBaseUIKit_Example
//
//  Created by cheng on 2020/3/3.
//

#import "WCMethodUtil.h"

NSString * readTxtFromPath(NSString *path)
{
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return string;
}

void writeTxtToPath(NSString *text, NSString *path)
{
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

BOOL CGFloatEqualToFloat(CGFloat f1, CGFloat f2)
{
    return fabs(f1 - f2) < 0.0001;
}

int CGFloatCompareWithFloat(CGFloat f1, CGFloat f2)
{
    if (CGFloatEqualToFloat(f1, f2)) {
        return 0;
    } else if (f1 > f2) {
        return 1;
    } else {
        return -1;
    }
}

CGFloat validValue(CGFloat f, CGFloat min, CGFloat max)
{
    if (f < min) {
        return min;
    } else if (f > max) {
        return max;
    }
    return f;
}

@implementation WCMethodUtil

@end
