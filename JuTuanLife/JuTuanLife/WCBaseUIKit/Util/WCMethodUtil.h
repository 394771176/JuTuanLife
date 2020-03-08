//
//  WCMethodUtil.h
//  Pods-WCBaseUIKit_Example
//
//  Created by cheng on 2020/3/3.
//

#import <Foundation/Foundation.h>

#define UICREATE(cla, x, y, w, h, AA, toV)   UICreate([cla class], RECT(x, y, w, h), AA, toV);
#define UICREATELabel(cla, x, y, w, h, AA, text, font, color, toV)   UICreateLabel([cla class], RECT(x, y, w, h), AA, text, font, color, toV);
#define UICREATEImg(cla, x, y, w, h, AA, CC, image, toV)    UICreateImage([cla class], RECT(x, y, w, h), AA, CC, image, toV);
#define UICREATEBtn(cla, x, y, w, h, AA, title, font, color, target, sel, toV)   UICreateBtn([cla class], RECT(x, y, w, h), AA, title, font, color, target, sel, toV);

#define UICREATETo(v, cla, x, y, w, h, AA, toV)       v = UICREATE(cla, x, y, w, h, AA, toV)
#define UICREATELabelTo(v, cla, x, y, w, h, AA, text, font, color, toV)    v = UICREATELabel(cla, x, y, w, h, AA, text, font, color, toV)
#define UICREATEImgTo(v, cla, x, y, w, h, AA, CC, image, toV)    v = UICREATEImg(cla, x, y, w, h, AA, CC, image, toV);
#define UICREATEBtnTo(v, cla, x, y, w, h, AA, title, font, color, target, sel, toV)    v = UICREATEBtn(cla, x, y, w, h, AA, title, font, color, target, sel, toV)

typedef NS_ENUM(NSUInteger, UIAutoResizingType) {
    AANone = UIViewAutoresizingNone,
    AAL = UIViewAutoresizingFlexibleLeftMargin,
    AAW = UIViewAutoresizingFlexibleWidth,
    AAR = UIViewAutoresizingFlexibleRightMargin,
    AAT = UIViewAutoresizingFlexibleTopMargin,
    AAH = UIViewAutoresizingFlexibleHeight,
    AAB = UIViewAutoresizingFlexibleBottomMargin,
    AAWH = AAW | AAH,
    AALR = AAL | AAR,
    AATB = AAT | AAB,
    AALRTB = AAL | AAR | AAT | AAB,
    AAWT = AAW | AAT,
};

typedef NS_ENUM(NSUInteger, UIContetntModeType) {
    CCCenter = UIViewContentModeCenter,
    CCFill = UIViewContentModeScaleToFill,
    CCAFit = UIViewContentModeScaleAspectFit,
    CCAFill = UIViewContentModeScaleAspectFill,
};

extern NSString * readTxtFromPath(NSString *path);

extern void writeTxtToPath(NSString *text, NSString *path);

extern BOOL CGFloatEqualToFloat(CGFloat f1, CGFloat f2);

/* 比较 f1 与 f2
 * 0 为 等于， 1 为 大于   -1 为小于
 */
extern int CGFloatCompareWithFloat(CGFloat f1, CGFloat f2);

extern CGFloat validValue(CGFloat f, CGFloat min, CGFloat max);

//自动识别 btn 类型，
extern id UICreate(Class uiClass, CGRect frame, UIAutoResizingType AA, UIView *toView);
extern id UICreateLabel(Class uiClass, CGRect frame, UIAutoResizingType AA, NSString *text, id font, id color, UIView *toView);
extern id UICreateImage(Class uiClass, CGRect frame, UIAutoResizingType AA, UIContetntModeType CC, id image, UIView *toView);
extern id UICreateBtn(Class uiClass, CGRect frame, UIAutoResizingType AA, NSString *title, id font, id color, id target, SEL action, UIView *toView);

@interface WCMethodUtil : NSObject

@end
