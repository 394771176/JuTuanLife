//
//  JTViewController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTViewController.h"
#import "JTLoginHomeController.h"

@interface JTViewController ()

@end

@implementation JTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = UICREATEBtn(UIButton, 100, 100, 100, 100, AAW, @"123", @"15", @"ff1234", self, @selector(btnAction), self.view);
    
    // Do any additional setup after loading the view.
}

- (void)btnAction
{
    if (self.view.tag) {
        PRESENT_VC(JTViewController);
    } else {
        [[JTCommon topContainerController] dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
