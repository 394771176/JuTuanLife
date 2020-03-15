//
//  DTShareItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/15.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTShareItem.h"

@implementation DTShareItem

- (DTShareContentType)contentType
{
    if (_contentType == DTShareContentTypeAuto) {
        if (_miniprogramUserName.length) {
            return DTShareContentTypeMiniProgram;
        } else if (self.link.length) {
            return DTShareContentTypeWebPage;
        } else if (self.image || self.imageUrl.length) {
            return DTShareContentTypePhoto;
        } else {
            return DTShareContentTypeText;
        }
    } else {
        return _contentType;
    }
}

- (NSString *)title {
    if (_title.length) {
        return _title;
    } else {
        return _desc;
    }
}

- (NSString *)desc
{
    if (_desc.length) {
        return _desc;
    } else {
        return _title;
    }
}

- (NSString *)text
{
    if (_text.length) {
        return _text;
    } else {
        return self.desc;
    }
}

- (NSString *)copyLink
{
    if (_copyLink.length) {
        return _copyLink;
    } else {
        return _link;
    }
}

- (UIImage *)thumbImage {
    if (_thumbImage) {
        return _thumbImage;
    } else if (_image) {
        if (_image.size.width > 60 || _image.size.height > 60) {
            CGRect rect = CGRectMake(0, 0, 60, 60);
            if (_image.size.width > 60) {
                rect.origin.x = (_image.size.width - 60) / 2;
            } else {
                rect.size.width = _image.size.width;;
            }
            if (_image.size.height > 60) {
                rect.origin.y = (_image.size.height - 60) / 2;
            } else {
                rect.size.height = _image.size.height;;
            }
            return [_image subImageFromRect:rect];
        } else {
            return _image;
        }
    } else {
        return [DTShareItem shareAppIcon];
    }
}

+ (UIImage *)shareAppIcon
{
    return [UIImage imageNamed:@"AppIcon60x60"];
}

@end
