//
//  CWDaijiaCommentStarView.m
//  ChelunWelfare
//
//  Created by cheng on 15/1/14.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import "CCCommentStarView.h"
#import "WCUICommon.h"

@interface CCCommentStarView () {
    NSMutableArray *_starItems;
//    UIImage *_fullStar, *_halfStar, *_emptyStar;
    NSArray *_starImages;
}

@end

@implementation CCCommentStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _starItems = [NSMutableArray array];
        CGFloat w = self.width/5;
        for (int i = 0; i<5; i++) {
            UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*w, 0, w, self.height)];
            starImageView.backgroundColor = [UIColor clearColor];
            starImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            starImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:starImageView];
            [_starItems addObject:starImageView];
        }
        self.canEdit = NO;
        self.backgroundColor = [UIColor clearColor];
        self.star = 0;
        
        _starImages = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"star_empty"],
                       [UIImage imageNamed:@"star_full"],
                       nil];
    }
    return self;
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    self.userInteractionEnabled = canEdit;
}

- (void)setCustomStarImages:(NSArray *)images
{
    if (images) {
        _starImages = images;
    }
}

- (UIImage *)starImage:(NSInteger)index
{
    if (index == 1) {
        if (_fullImage) {
            return _fullImage;
        }
    } else {
        if (index == 2 && _halfImage) {
            return _halfImage;
        } else if (_emptyImage) {
            return _emptyImage;
        }
    }

    if (index<_starImages.count) {
        return _starImages[index];
    } else if (_starImages.count>0) {
        return _starImages[0];
    }
    return nil;
}

- (void)setStar:(NSInteger)star
{
    if (star<0) {
        star=0;
    } else if (star>10) {
        star=10;
    }
    _star = star;
    int n = (int)star/2;
    for (int i=0; i<_starItems.count; i++) {
        UIImageView *imageView = _starItems[i];
        if (i<n) {
            imageView.image = [self starImage:1];
        } else if (i>n) {
            imageView.image = [self starImage:0];
        } else {
            if (star%2!=0) {
                imageView.image = [self starImage:2];
            } else {
                imageView.image = [self starImage:0];
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([event allTouches].count<2) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.star = floorf(point.x/self.height)+1;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([event allTouches].count<2) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.star = floorf(point.x/self.height)+1;
    }
}

@end
