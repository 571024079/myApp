//
//  FullScreenLeftListForRightHeaderView.h
//  HandleiPad
//
//  Created by handou on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullScreenLeftListForRightHeaderViewDelegate <NSObject>
- (void)bottomViewButtonActionForHeader:(UIButton *)sender;

@end

@interface FullScreenLeftListForRightHeaderView : UIView

@property (nonatomic, assign) id<FullScreenLeftListForRightHeaderViewDelegate>delegate;

//中间的View
@property (weak, nonatomic) IBOutlet UIView *bottomView1;//第一个view
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel1;//第一个label
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage1;//第一个imageView
@property (weak, nonatomic) IBOutlet UIButton *bottomButton1;//第一个button

@property (weak, nonatomic) IBOutlet UIView *bottomView2;//第二个view
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel2;//第二个label
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage2;//第二个imageView
@property (weak, nonatomic) IBOutlet UIButton *bottomButton2;//第二个button

@property (weak, nonatomic) IBOutlet UIView *bottomView3;//第三个view
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel3;//第三个label
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage3;//第三个imageView
@property (weak, nonatomic) IBOutlet UIButton *bottomButton3;//第三个button

@property (weak, nonatomic) IBOutlet UIView *bottomView4;//第四个view
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel4;//第四个label
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage4;//第四个imageView
@property (weak, nonatomic) IBOutlet UIButton *bottomButton4;//第四个button

@property (weak, nonatomic) IBOutlet UIView *bottomView5;//第五个view
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel5;//第五个label
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage5;//第五个imageView
@property (weak, nonatomic) IBOutlet UIButton *bottomButton5;//第五个button


//下面的界面（新版本）
@property (weak, nonatomic) IBOutlet UILabel *jinriJiaocheLabel;//今日交车
@property (weak, nonatomic) IBOutlet UILabel *yiguoYujiJiaocheShijianLabel;//已过预计交车时间
@property (weak, nonatomic) IBOutlet UILabel *zaichangCheliangZongjiLabel;//在厂车辆总计
@property (weak, nonatomic) IBOutlet UILabel *kehuYiQuerenLabel;//客户已确认


@end
