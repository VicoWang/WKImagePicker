//
//  WKImagePicker.m
//
//  Created by wangkun on 16/7/25.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import "WKImagePicker.h"
#import "WKImagePickerController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

static WKImagePicker *wkImagePicker = nil;
static UIViewController *wkViewController = nil;
static NSString *const WKCaptureAuthorizationHintString = @"请在iPhone的“设置-隐私-相机”选项中，允许访问您的相机";

@interface WKImagePicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, copy) ChooseCallBack chooseBlock;   //选取回调
@property (nonatomic, copy) CancelCallBack cancelBlock;   //取消回调
@end

@implementation WKImagePicker

+ (void)startWKImagePicker:(UIViewController *)viewController
            chooseCallBack:(ChooseCallBack)chooseBlock
            cancelCallBack:(CancelCallBack)cancelBlock {
    
    wkImagePicker = [[self alloc]initWithChooseCallBack:chooseBlock
                                         cancelCallBack:cancelBlock];
    wkViewController = viewController;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [wkImagePicker presentPickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
   
            [wkImagePicker presentPickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:action];
        [alertC addAction:action1];
        [alertC addAction:action3];
        [viewController presentViewController:alertC
                                     animated:YES
                                   completion:^{
                                   }];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                          delegate:wkImagePicker
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet showInView:viewController.view];
    }
}

//初始化
- (instancetype)initWithChooseCallBack:(ChooseCallBack)chooseBlock
                        cancelCallBack:(CancelCallBack)cancelBlock {
    if (self = [super init]) {
        _chooseBlock = [chooseBlock copy];
        _cancelBlock = [cancelBlock copy];
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"获取成功");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_chooseBlock) {
            _chooseBlock(info);
        }
        wkImagePicker = nil;
        wkViewController = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_cancelBlock) {
            _cancelBlock();
        }
        wkImagePicker = nil;
        wkViewController = nil;
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [wkImagePicker presentPickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [wkImagePicker presentPickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            break;
    }
}

#pragma mark - private methods
- (void)presentPickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {

    WKImagePickerController *imagePickerC = [[WKImagePickerController alloc]init];
    imagePickerC.sourceType = sourceType;
    imagePickerC.delegate = wkImagePicker;
    imagePickerC.allowsEditing = YES;
    [wkViewController presentViewController:imagePickerC animated:YES completion:^{
        
        if (sourceType != UIImagePickerControllerSourceTypeCamera) {
            return ;
        }
        //判断相机权限,无权限加alert提醒
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:WKCaptureAuthorizationHintString delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)dealloc {
    NSLog(@"WKImagePicker -- dealloc");
}
@end
