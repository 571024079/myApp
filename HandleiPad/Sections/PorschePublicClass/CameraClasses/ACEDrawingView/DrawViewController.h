//
//  DrawViewController.h
//  DrawImageViewDemo
//
//  Created by GoodRobin on 16/9/21.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACEDrawingView.h"

typedef enum : NSUInteger {
    DrawViewControllerFromOther,
    DrawViewControllerFromCamera,

} DrawViewControllerFromType;

typedef void(^photoDoneBlock) (UIImage *image,NSString *mark,BOOL isCovers, NSMutableArray *paths);
typedef void(^photoDeleteBlock)();
@interface DrawViewController : UIViewController

//图片
@property (nonatomic, strong) UIImage *image;
// 原图Url
@property (nonatomic, strong) NSURL *imageUrl;
//备注信息
@property (nonatomic, strong) NSString *markString;
// 是否为封面
@property (nonatomic) BOOL isCovers;
//完成照片编辑回调编辑后的照片
@property (nonatomic, copy) photoDoneBlock doneBlock;
@property (nonatomic, copy) photoDeleteBlock deleteBlock;

@property (nonatomic, copy) NSMutableArray *pathArray;
@property (nonatomic) DrawViewControllerFromType fromType;
@end
