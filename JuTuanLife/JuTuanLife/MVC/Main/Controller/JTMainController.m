//
//  JTMainController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMainController.h"

@implementation JTMainController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [JTCommon setMainController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
