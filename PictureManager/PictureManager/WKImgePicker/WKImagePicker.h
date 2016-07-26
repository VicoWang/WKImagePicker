//
//  WKImagePicker.h
//
//  Created by wangkun on 16/7/25.
//  Copyright © 2016年 wangkun. All rights reserved.
//
//note: info.plist add key - value : Localized resources can be mixed - YES

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  选取成功回调
 *  对应imagePickerController:didFinishPicking方法
 */
typedef void(^ChooseCallBack)(NSDictionary<NSString *,id> *info);

/**
 *  取消回调
 *  对应imagePickerControllerDidCancel:
 */
typedef void(^CancelCallBack)(void);

@interface WKImagePicker : NSObject

/**
 *  提供给外界的接口
 *
 *  @param viewController 用来present的控制器
 *  @param chooseBlock    选取成功回调
 *  @param cancelBlock    取消回调
 */
+ (void)startWKImagePicker:(UIViewController *)viewController
            chooseCallBack:(ChooseCallBack)chooseBlock
            cancelCallBack:(CancelCallBack)cancelBlock;

@end
