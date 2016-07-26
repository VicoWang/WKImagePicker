//
//  WKImagePickerController.m
//
//  Created by wangkun on 16/7/25.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import "WKImagePickerController.h"

@interface WKImagePickerController ()

@end

@implementation WKImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
