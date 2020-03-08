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

UIColor *ColorFrom(id color)
{
    if (color) {
        if ([color isKindOfClass:UIColor.class]) {
            return color;
        } else if ([color isKindOfClass:NSString.class]) {
            return [UIColor colorWithString:color];
        }
    }
    return [UIColor clearColor];
}

UIFont *FontFrom(id font) {
    if (font) {
        if ([font isKindOfClass:UIFont.class]) {
            return font;
        } else if ([font isKindOfClass:NSNumber.class] || [font isKindOfClass:NSString.class]) {
            return [UIFont systemFontOfSize:[font integerValue]];
        }
    }
    return [UIFont systemFontOfSize:16];
}

UIImage *ImageFrom(id image) {
    if (image) {
        if ([image isKindOfClass:UIImage.class]) {
            return image;
        } else if ([image isKindOfClass:NSString.class]) {
            return [UIImage imageNamed:image];
        }
    }
    return nil;
}


id UICreate(Class uiClass, CGRect frame, UIAutoResizingType AA, UIView *toView)
{
    UIView *view = nil;
    if ([uiClass isKindOfClass:UIButton.class]) {
        view = [uiClass buttonWithType:UIButtonTypeCustom];
        [view setFrame:frame];
    } else {
        view = [[uiClass alloc] initWithFrame:frame];
    }
    view.autoresizingMask = (UIViewAutoresizing)AA;
    if (toView) {
        [toView addSubview:view];
    }
    return view;
}

id UICreateLabel(Class uiClass, CGRect frame, UIAutoResizingType AA, NSString *text, id font, id color, UIView *toView)
{
    UILabel *label = UICreate(uiClass, frame, AA, toView);
    label.text = text;
    label.font = FontFrom(font);
    label.textColor = ColorFrom(color);
    return label;
}

id UICreateImage(Class uiClass, CGRect frame, UIAutoResizingType AA, UIContetntModeType CC, id image, UIView *toView)
{
    UIImageView *imageView = nil;
    UIImage *img = ImageFrom(image);
    if (CGRectEqualToRect(frame, CGRectZero) && img) {
        imageView = [[uiClass alloc] initWithImage:img];
    } else {
        imageView = UICreate(uiClass, frame, AA, toView);
        imageView.image = img;
    }
    imageView.contentMode = (UIViewContentMode)CC;
    return imageView;
}

id UICreateBtn(Class uiClass, CGRect frame, UIAutoResizingType AA, NSString *title, id font, id color, id target, SEL action, UIView *toView)
{
    UIButton *btn = UICreate(uiClass, frame, AA, toView);
    [btn setTitle:title];
    [btn setTitleFont:FontFrom(font)];
    [btn setTitleColor:ColorFrom(color)];
    
    if (target && action && [target respondsToSelector:action]) {
        [btn addTarget:target action:action];
    }
    
    return btn;
}

@implementation WCMethodUtil

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

@end
