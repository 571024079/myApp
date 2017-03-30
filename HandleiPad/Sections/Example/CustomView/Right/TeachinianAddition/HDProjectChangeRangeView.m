//
//  HDProjectChangeRangeView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDProjectChangeRangeView.h"
#import "HDProjectUserRangeTableViewCell.h"
#import "HDMoreListView.h"
@interface HDProjectChangeRangeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *contentView;


@end


@implementation HDProjectChangeRangeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (HDProjectChangeRangeView *)showRangeViewWithProjectArray:(NSMutableArray *)projectArray block:(HDProjectChangeRangeViewBlock)block {
    
    HDProjectChangeRangeView *view = [[HDProjectChangeRangeView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.dataSource = projectArray;
    [view.tableView reloadData];
    view.hDProjectChangeRangeViewBlock = block;
    
    [KEY_WINDOW addSubview: view];
    return view;
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = nibArray.firstObject;
    self.frame = frame;
    [self setupDefaultImageView];
    [self setupViewCornerRadiusWithView:self radius:5];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDProjectUserRangeTableViewCell class]) bundle:nil ]forCellReuseIdentifier:NSStringFromClass([HDProjectUserRangeTableViewCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self sureImageInit];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    return self;
}

- (void)sureImageInit {
    UIImage *image = [UIImage imageNamed:@"Billing_right_bottom_save.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _sureImg.tintColor = Color(255, 255, 255);
    _sureImg.image = image;
}



#pragma mark  tableView代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDProjectUserRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HDProjectUserRangeTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WeakObject(self);
    WeakObject(cell);
    cell.projectLb.text = [NSString stringWithFormat:@"方案%ld",(long)indexPath.row];
    
    cell.hdProjectBlock = ^(UIButton *button) {
      
        [selfWeak isInitListViewWithView:cellWeak.textField direction:UIPopoverArrowDirectionDown];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


- (void)isInitListViewWithView:(UITextField *)view direction:(UIPopoverArrowDirection)direction{
    WeakObject(view);
    [HDMoreListView showListViewWithView:view Data:[NSMutableArray arrayWithArray:@[@"临时修改",@"存为我的方案",@"替换原方案适用于全厂"]] direction:UIPopoverArrowDirectionDown complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
        viewWeak.text = contentOne.cvvaluedesc;
    }];

}

//确定 取消
- (IBAction)sureOrCancelbtAction:(UIButton *)sender {

    switch (sender.tag) {
            //确定
        case 1:
        {
            
        }
            break;
            //取消
            
            
            
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    if (self.hDProjectChangeRangeViewBlock) {
        self.hDProjectChangeRangeViewBlock(sender);
    }
    [self removeFromSuperview];

}
//批量设置按钮 sender.tag  3.临时修改 4.存为我的方案 5.替换为试用于全厂
- (IBAction)changeAllRangeBtAction:(UIButton *)sender {
    [self setupDefaultImageView];

    switch (sender.tag) {
        case 3:
        {
            [self setupViewBorderWithView:_momentImg width:0 color:MAIN_BLUE];

        }
            break;
        case 4:
        {
            [self setupViewBorderWithView:_saveMineImg width:0 color:MAIN_BLUE];

        }
            break;
        case 5:
        {
            [self setupViewBorderWithView:_forAllImg width:0 color:MAIN_BLUE];

        }
            break;
        default:
            break;
    }
}


//默认显示
- (void)setupDefaultImageView {
    //设置圆角
    [self setupViewCornerRadiusWithView:_momentImg radius:7];
    [self setupViewCornerRadiusWithView:_saveMineImg radius:7];
    [self setupViewCornerRadiusWithView:_forAllImg radius:7];
    //设置边框颜色
    [self setupViewBorderWithView:_momentImg width:0.5 color:Color(255, 255, 255)];
    [self setupViewBorderWithView:_saveMineImg width:0.5 color:Color(255, 255, 255)];
    [self setupViewBorderWithView:_forAllImg width:0.5 color:Color(255, 255, 255)];

}


//圆角
- (void)setupViewCornerRadiusWithView:(UIView *)view radius:(CGFloat)radius {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
}
//边框及背景色
- (void)setupViewBorderWithView:(UIView *)view width:(CGFloat)width color:(UIColor *)color {
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = Color(170, 170, 170).CGColor;
    view.backgroundColor = color;
}

- (IBAction)listBtAction:(UIButton *)sender {
    
    [self isInitListViewWithView:_textField direction:UIPopoverArrowDirectionDown];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        
        return [super hitTest:point withEvent:event];
    }
    [self removeFromSuperview];
    
    return nil;
}

@end
