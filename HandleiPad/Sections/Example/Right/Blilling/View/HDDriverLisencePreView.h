//
//  HDDriverLisencePreView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HDDriverLisencePreViewStyle) {
    HDDriverLisencePreViewStyleShutDown = 1,// 关闭
    HDDriverLisencePreViewStyleReTakePhoto,//重拍
    HDDriverLisencePreViewStyleDelete,//删除
};

typedef void(^HDDriverLisencePreViewBlock)(HDDriverLisencePreViewStyle,UIButton *);




@interface HDDriverLisencePreView : UIView

@property (nonatomic, copy) HDDriverLisencePreViewBlock hDDriverLisencePreViewBlock;

//关闭
@property (weak, nonatomic) IBOutlet UIButton *shutDownBt;
//重拍
@property (weak, nonatomic) IBOutlet UIButton *reTakePhotoBt;
//删除
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;



- (IBAction)ShutDownAction:(UIButton *)sender;

- (IBAction)reTakePhoto:(UIButton *)sender;

- (IBAction)deleteBtAction:(UIButton *)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;

















@end
