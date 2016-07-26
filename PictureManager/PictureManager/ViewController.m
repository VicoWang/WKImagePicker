//
//  ViewController.m
//  PictureManager
//
//  Created by wangkun on 16/7/25.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import "ViewController.h"
#import "WKImagePicker.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)click:(id)sender {
    
    __weak typeof(UIButton *) weakSender = sender;
    [WKImagePicker startWKImagePicker:self chooseCallBack:^(NSDictionary<NSString *,id> *info) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [weakSender setImage:image forState:UIControlStateNormal];
        
    } cancelCallBack:^{
        

    }];
}


@end
