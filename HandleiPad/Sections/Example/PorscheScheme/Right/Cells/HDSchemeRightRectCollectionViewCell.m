//
//  HDSchemeRightRectCollectionViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSchemeRightRectCollectionViewCell.h"

@interface HDSchemeRightRectCollectionViewCell ()

//方案名
@property (weak, nonatomic) IBOutlet UILabel *schemeNameLabel;
//方案总价
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
//工时第一个名字
@property (weak, nonatomic) IBOutlet UILabel *workTimeNameLabel;
//工时第一个价格
@property (weak, nonatomic) IBOutlet UILabel *workTimePrice;
//备件第一个名字
@property (weak, nonatomic) IBOutlet UILabel *materialFirstNameLabel;
//备件第一个价格
@property (weak, nonatomic) IBOutlet UILabel *materialFirstPrice;
//备件第二个名字
@property (weak, nonatomic) IBOutlet UILabel *materialSecondNameLabel;
//备件第二个价格
@property (weak, nonatomic) IBOutlet UILabel *materialSecondPrice;
//车型Label
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
//公里数范围
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
//打钩
@property (weak, nonatomic) IBOutlet UIImageView *chickImageView;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//业务分类
@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;
//安全级别
@property (weak, nonatomic) IBOutlet UIImageView *schemeCatoryImageView;

@property (nonatomic, strong) UIImageView *cutView;

@property (nonatomic, strong) UIView *clear;

@end

@implementation HDSchemeRightRectCollectionViewCell {
    
    CGPoint _startLocation;
    
    BOOL _showDetail;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupconfig];
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"HDSchemeRightRectCollectionViewCell";
    [collectionView registerNib:[UINib nibWithNibName:@"HDSchemeRightRectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    HDSchemeRightRectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    UILongPressGestureRecognizer *longZer = [[UILongPressGestureRecognizer alloc] initWithTarget:cell action:@selector(showDetaileView:)];
    [cell addGestureRecognizer:longZer];
    [cell makeCellSandow:cell.carTypeLabel];
    [cell makeCellSandow:cell.mileageLabel];
    return cell;
}

- (UIImageView *)cutView {
    
    if (!_cutView) {
        _cutView = [[UIImageView alloc] init];
        _cutView.image = [self imageFromView:self Rect:self.bounds];
    }
    
    return _cutView;
}

- (UIView *)clear {
    
    if (!_clear) {
        _clear = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
        _clear.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        hint.text = @"松手显示方案详情";
        hint.textAlignment = 1;
        hint.backgroundColor = [UIColor whiteColor];
        hint.font = [UIFont systemFontOfSize:15];
        hint.tag = 2222;
        [_clear addSubview:hint];
    }
    return _clear;
}

- (void)showHintPoint:(CGPoint)point {
    
    UILabel *hint = [self.clear viewWithTag:2222];
    hint.center = CGPointMake(point.x, point.y - 120);
    [KEY_WINDOW addSubview:self.clear];
}
- (void)hiddenHint {
    [self.clear removeFromSuperview];
    self.clear = nil;
}


- (void)showDetaileView:(UILongPressGestureRecognizer *)longZer {
    
    CGPoint loc = [longZer locationInView:KEY_WINDOW];
    switch (longZer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startLocation = [longZer locationInView:KEY_WINDOW];
            _showDetail = YES;
            [self showHintPoint:_startLocation];
            
            if (self.cutView.superview != KEY_WINDOW) {
                
                self.cutView.frame = [self convertRect:self.bounds toView:KEY_WINDOW];
                [KEY_WINDOW addSubview:self.cutView];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"loc == %@",NSStringFromCGPoint(loc));
            _showDetail = NO;
            self.cutView.center = loc;
            
            if (fabs(loc.x - _startLocation.x) > 10 || fabs(loc.y - _startLocation.y) > 10) {
                
                [UIView animateWithDuration:0.35 animations:^{
                    self.cutView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                }];
                [self hiddenHint];
                [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_MOVERECTCELL_NOTIFICATION object:@{@"model":self.schemeModel,@"point":NSStringFromCGPoint(loc),@"endPoint":@(0)}];
                
            } else {
                
                _showDetail = YES;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_showDetail) {
                [self hiddenHint];
                if (self.longBlock) {
                    self.longBlock();
                }
            } else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_MOVERECTCELL_NOTIFICATION object:@{@"model":self.schemeModel,@"point":NSStringFromCGPoint(loc),@"endPoint":@(1)}];
            }
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.cutView.transform = CGAffineTransformMakeScale(0.2, 0.2);
                self.cutView.alpha = 0;
            } completion:^(BOOL finished) {
                
                [self.cutView removeFromSuperview];
                self.cutView.alpha = 1.0;
                self.cutView = nil;
            }];
            
        }
            break;
            
        default:
            break;
    }
}

- (UIImage *)imageFromView:(UIView *)view  Rect:(CGRect)rect
{
    //创建一个基于位图的图形上下文并指定大小为CGSizeMake(300,500)
    UIGraphicsBeginImageContext(rect.size);
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *extractImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    
    //以png格式返回指定图片的数据
    NSData *imageData = UIImagePNGRepresentation(extractImage);
    UIImage *imge = [UIImage imageWithData:imageData];
    
    return imge;
}


- (void)makeCellSandow:(UIView *)view {
    
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 2;
}


- (void)setSchemeModel:(PorscheSchemeModel *)schemeModel {
    
    _schemeModel = schemeModel;
    
    self.schemeNameLabel.text = schemeModel.schemename;
    
    self.totalPriceLabel.text = [NSString formatMoneyStringWithFloat:schemeModel.schemeprice.floatValue];
    
    //工时
    PorscheSchemeWorkHourModel *workHourModel = [schemeModel.workhourlist firstObject];
    self.workTimeNameLabel.text = workHourModel.workhourname ? workHourModel.workhourname : @"";
    self.workTimePrice.text = [NSString formatMoneyStringWithFloat:workHourModel.workhourpriceall.floatValue];
    
    if (!self.workTimeNameLabel.text.length) {
        self.workTimePrice.text = @"";
    }
    
    
    // 先清数据
    self.materialFirstNameLabel.text = @"";//subModel.parts_name;
    self.materialFirstPrice.text = @"";//[NSString formatMoneyStringWithFloat:subModel.sparepriceall.floatValue];
    
    self.materialSecondNameLabel.text = @"";//subModel.parts_name;
    self.materialSecondPrice.text = @"";//[NSString formatMoneyStringWithFloat:subModel.sparepriceall.floatValue];
    
    //备件
    for (NSInteger i = 0; i < schemeModel.sparelist.count; i ++) {
        
        PorscheSchemeSpareModel *subModel = schemeModel.sparelist[i];
        

        if (i == 0) {
            self.materialFirstNameLabel.text = subModel.parts_name;
            self.materialFirstPrice.text = [NSString formatMoneyStringWithFloat:subModel.sparepriceall.floatValue];
        }
        
        if (i == 1) {
            self.materialSecondNameLabel.text = subModel.parts_name;
            self.materialSecondPrice.text = [NSString formatMoneyStringWithFloat:subModel.sparepriceall.floatValue];
        }
    }
    //车型
    PorscheSchemeCarModel *carModel = [self.schemeModel.carlist firstObject];
    
    self.carTypeLabel.text = carModel ?  carModel.wocarcatena : @"";
    
    self.businessImageView.image = [UIImage imageNamed:[PorscheImageManager getSchemeBusinessSmallIconImage:self.schemeModel.schemelevelid.integerValue]];
    
    self.schemeCatoryImageView.image = [UIImage imageNamed:[PorscheImageManager getSafetyImage:self.schemeModel.schemelevelid.integerValue selected:NO]];
    
    CGFloat startMiles = 0;
    CGFloat endMiles = 0;
    switch (schemeModel.miles.rangetype.integerValue) { //1：公里范围 2:公里数浮动 3：公里数循环
        case 1:
        {
            startMiles = schemeModel.miles.beginmiles.floatValue;
            endMiles = schemeModel.miles.endmiles.floatValue;
            if (endMiles == 0)
            {
                self.mileageLabel.text = @"- ~ - 公里";
            }
            else
            {
                self.mileageLabel.text = [NSString stringWithFormat:@"%.f ~%.f万公里",startMiles,endMiles];
            }

        }
            
            break;
        case 2:
        {
            startMiles = schemeModel.miles.allmiles.floatValue - schemeModel.miles.downfloatmiles.floatValue;
            endMiles = schemeModel.miles.allmiles.floatValue + schemeModel.miles.upfloatmiles.floatValue ;
            if (endMiles == 0)
            {
                self.mileageLabel.text = @"- ~ - 公里";
            }
            else
            {
                self.mileageLabel.text = [NSString stringWithFormat:@"%.f ~%.f万公里",startMiles,endMiles];
            }

        }
            break;
        case 3:
        {
            startMiles = schemeModel.miles.startmiles.floatValue + schemeModel.miles.personmemiles.floatValue - schemeModel.miles.downfloatmiles.floatValue;
            endMiles = schemeModel.miles.startmiles.floatValue + schemeModel.miles.personmemiles.floatValue + schemeModel.miles.upfloatmiles.floatValue;
            
            self.mileageLabel.text = [NSString stringWithFormat:@"首%.f 每%.f",schemeModel.miles.startmiles.floatValue,schemeModel.miles.personmemiles.floatValue];
        }
            break;
        default:
            self.mileageLabel.text = @"- ~ - 公里";
            break;
    }
    
    [self setImageShandow:self shandow:NO];
}

- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;
     [self setImageShandow:self shandow:cellSelected];
}

- (UIColor *)getShandowColor:(PorscheItemModelCategooryStyle)style {
    
    UIColor *color;
    switch (style) {
        case PorscheItemModelCategooryStyleSave:
            color = Color(128, 0, 0);
            break;
        case PorscheItemModelCategooryStyleMessage:
            color = MAIN_BLUE;
            break;
        case PorscheItemModelCategooryStyleHiddenDanger:
            color = [UIColor blackColor];
            break;
        case PorscheItemModelCategooryStyleCustom:
            color = [UIColor grayColor];
            break;
        default:
            color = [UIColor greenColor];
            break;
    }
    
    return color;
}

- (void)setupconfig {
    
    self.workTimeNameLabel.text = @"";
    self.materialFirstNameLabel.text = @"";
    self.materialSecondNameLabel.text = @"";
}

- (void)setImageShandow:(UIView *)view shandow:(BOOL)shandow{
    
    if (shandow) {
        self.clipsToBounds = NO;
        UIColor *color = [self getShandowColor:self.schemeModel.schemelevelid.integerValue];
        view.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
        view.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOpacity = 1.0;//阴影透明度，默认0
        view.layer.shadowRadius = 4;//阴影半径，默认3
        self.chickImageView.image = [UIImage imageNamed:@"materialtime_list_checkbox_selected"];
    }else {
        
        view.layer.shadowColor = [UIColor clearColor].CGColor;//shadowColor阴影颜色
        self.clipsToBounds = YES;
        self.chickImageView.image = [UIImage imageNamed:@"materialtime_list_checkbox_normal"];
    }
    
    NSString *imageName = [PorscheImageManager getSchemeRectItemBackImage:self.schemeModel.schemelevelid.integerValue selected:shandow];
    self.backgroundImageView.image = [UIImage imageNamed:imageName];
}

@end
