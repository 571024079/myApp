//
//  TeachicianAdditionItemBottomView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "TeachicianAdditionItemBottomView.h"
#import "HDLeftSingleton.h"
@interface TeachicianAdditionItemBottomView ()

@property (nonatomic, assign) BottomConstantSaveStyle style;

@end

@implementation TeachicianAdditionItemBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (instancetype)getCustomFrame:(CGRect)frame style:(BottomConstantSaveStyle)style{
        
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TeachicianAdditionItemBottomView" owner:self options:nil];
    TeachicianAdditionItemBottomView *view = [array objectAtIndex:0];
    view.frame = frame;
    view.style = style;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowRadius = 3;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    [view setupInitTFWithBool:NO];
    view.bottomStyle = style;
    view.saveStatus = @0;
    view.confirmStatus = @1;
    switch (style) {
        case BottomConstantSaveStyleTechician:
        {
            view.saveViewWidth.constant = - CGRectGetWidth(view.saveSuperBt.frame)/2;
            view.saveSuperBt.hidden = NO;
            view.lineView.backgroundColor = [UIColor whiteColor];
            view.printImg.hidden = YES;
            view.printLb.hidden = YES;
            view.techicianPullImg.hidden = YES;
            view.techicianViewWidth.constant = 40;
          
        }
            break;
        case BottomConstantSaveStylematerial:
        {
            view.saveViewWidth.constant = - CGRectGetWidth(view.saveSuperBt.frame)/2;
            view.materialHelperPullImg.hidden = YES;
            view.saveSuperBt.hidden = NO;
            view.lineView.backgroundColor = [UIColor whiteColor];
            view.printImg.hidden = YES;
            view.printLb.hidden = YES;
            view.techicianPullImg.hidden = YES;
            view.materialViewWidth.constant = 40;
        }
            break;
        case BottomConstantSaveStyleService:
            view.pullImg.hidden = YES;
            [AlertViewHelpers setupCellTFView:view.materialHelperTF save:YES];
            view.serviceHelperBt.userInteractionEnabled = NO;
            view.saveSuperBt.hidden = YES;
            view.serviceViewWidth.constant = 40;
            break;
        default:
            break;
    }
    [view setupDefalutSureBt];
    return view;
}

- (void)setupDefalutSureBt {
    switch (_bottomStyle) {
        case BottomConstantSaveStyleTechician:
        {
            if (_carMessage) {
                BOOL isShowTech = [_carMessage.orderstatus isShowTechicianText];
                [_techicianSurebt setTitle:isShowTech ? @"技师确认":@"车间确认" forState:UIControlStateNormal];
                if (!isShowTech) {
                    [self setuptechSureBt:NO];
                }else {
                    [self setuptechSureBt:![_carMessage.orderstatus isShowTechicianLighting]];
                }
            }
        }
            break;
        case BottomConstantSaveStylematerial:
        {
            [_techicianSurebt setTitle:@"备件确认" forState:UIControlStateNormal];
            [self setuptechSureBt:![_carMessage.orderstatus isShowMaterialLighting]];
        }
            break;
        case BottomConstantSaveStyleService:
        {
            [_techicianSurebt setTitle:@"服务确认" forState:UIControlStateNormal];
            [self setuptechSureBt:![_carMessage.orderstatus isShowServiceConfirmBtLighting]];
        }
            break;
        default:
            break;
    }
}


//初始化，边框，有交互，有下拉图片
- (void)setupInitTFWithBool:(BOOL)save {
    
    switch (_style) {
        case BottomConstantSaveStyleTechician:
        {
            [AlertViewHelpers setupCellTFView:_serviceHelperTF save:save];
            [AlertViewHelpers setupCellTFView:_materialHelperTF save:save];
//            [AlertViewHelpers setupCellTFView:_techicianTF save:YES];


        }
            break;
        case BottomConstantSaveStylematerial:
        {
            [AlertViewHelpers setupCellTFView:_serviceHelperTF save: save];
//            [AlertViewHelpers setupCellTFView:_materialHelperTF save:YES];
            [AlertViewHelpers setupCellTFView:_techicianTF save:save];

        }
            break;
        case BottomConstantSaveStyleService:
        {
//            [AlertViewHelpers setupCellTFView:_materialHelperTF save:save];
            [AlertViewHelpers setupCellTFView:_materialHelperTF save:save];

            [AlertViewHelpers setupCellTFView:_techicianTF save:save];

        }
            break;
        default:
            break;
    }
    
    
    
    
    
}
//
- (IBAction)techcianHelperBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.teachicianAdditionItemBottomViewBlock) {
        if (sender.tag == 4) {
            self.teachicianAdditionItemBottomViewBlock(TeachicianAdditionItemBottomViewStyleTechicianHelperBt,sender);
        }else if (sender.tag == 5) {
           self.teachicianAdditionItemBottomViewBlock(TeachicianAdditionItemBottomViewStyleMaterialHelperBt,sender);
        }else if (sender.tag == 6) {
            self.teachicianAdditionItemBottomViewBlock(TeachicianAdditionItemBottomViewStyleServiceHelperBt,sender);
        }
    }
}

- (IBAction)saveBtAction:(UIButton *)sender {
    if (self.teachicianAdditionItemBottomViewBlock) {
        self.teachicianAdditionItemBottomViewBlock(TeachicianAdditionItemBottomViewStyleSavebt,sender);
    }
}

- (IBAction)techcianSureBtAction:(UIButton *)sender {
    if (self.teachicianAdditionItemBottomViewBlock) {
        self.teachicianAdditionItemBottomViewBlock(TeachicianAdditionItemBottomViewStyleTechcianSureBt,sender);
    }
}
//TODO: 保存状态下，选择下拉，框和图标需要隐藏，见新UI
//YES显示编辑。NO显示保存
- (void)setSaveLbTittleAndImgBool:(BOOL)isSave {
    _saveStatus = isSave ? @1: @0;
    if (isSave) {
        _saveLb.text = @"编辑";
        _saveImg.image = [UIImage imageNamed:@"Billing_right_bottom_edit.png"];
    }else {
        _saveLb.text = @"保存";
        _saveImg.image = [UIImage imageNamed:@"Billing_right_bottom_save.png"];
    }
    
    [self setupInitTFWithBool:isSave];
    [self isHiddenPullImage:isSave];
    [self changeSureBtWithBool:isSave];
}

- (void)isHiddenPullImage:(BOOL)issave {
    
    switch (_style) {
        case BottomConstantSaveStyleTechician:
        {
            _techicianPullImg.hidden = YES;
            _pullImg.hidden = issave;
            _materialHelperPullImg.hidden = issave;
            
        }
            break;
        case BottomConstantSaveStylematerial:
        {
            _techicianPullImg.hidden = issave;
            _pullImg.hidden = issave;
            _materialHelperPullImg.hidden = YES;
            
        }
            break;
        case BottomConstantSaveStyleService:
        {
            _techicianPullImg.hidden = issave;
            _pullImg.hidden = YES;
            _materialHelperPullImg.hidden = issave;

            
        }
            break;
        default:
            break;
    }
}

- (void)changeSureBtWithBool:(BOOL)isBool {
    if  ([_confirmStatus integerValue] != 1) {
        isBool = NO;
    }
    [self setuptechSureBt:isBool];
    //可编辑时 查看是否可再次确认
    if (!isBool) {
        [self setupDefalutSureBt];
    }
}

- (void)setuptechSureBt:(BOOL)isSave {
    [_techicianSurebt setBackgroundImage:isSave ? [UIImage imageNamed:@"gray_backGroundImage.png"]: [UIImage imageNamed:@"sure_bg_blue.png"] forState:UIControlStateNormal];
    [_techicianSurebt setTitleColor:isSave ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    _techicianSurebt.userInteractionEnabled = !isSave;
}

- (void)setCarMessage:(PorscheNewCarMessage *)carMessage {
    _carMessage = carMessage;
    
    _billingPerson.text = carMessage.createusername;
    _techicianTF.text = carMessage.technicianname;
    _materialHelperTF.text = carMessage.wopartsmanname;
    _serviceHelperTF.text = carMessage.serviceadvisorname;
    
    if (_bottomStyle == BottomConstantSaveStyleTechician)
    {
        BOOL isShowTech = [_carMessage.orderstatus isShowTechicianText];
        [_techicianSurebt setTitle:isShowTech ? @"技师确认":@"车间确认" forState:UIControlStateNormal];
    }
    else if (_bottomStyle == BottomConstantSaveStyleService)
    {
        NSString *title = @"";
        if ([carMessage.orderstatus.servicedisplay integerValue] == 1)
        {
            title = @"保修审核中";
        }
        else
        {
            title = @"服务确认";
        }
        [_techicianSurebt setTitle:title forState:UIControlStateNormal];

    }
}

- (IBAction)printButtonAction:(id)sender {
    if (self.teachicianAdditionItemBottomViewBlock) {
        self.teachicianAdditionItemBottomViewBlock(TeachicianAdditionItemBottomViewStylePrintHelperBt,sender);
    }
}

@end
