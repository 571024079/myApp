//
//  ServiceShareListView.m
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ServiceShareListView.h"
#import "ServiceShareListTableViewCell.h"
#import "ShareUtil.h"
#import "PorschePrintAffirmView.h"

typedef enum : NSUInteger {
    ShareWechat,
    ShareMail,
} ShareType;

@interface ServiceShareListView () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *popTableView;

@property (nonatomic, strong)UIPopoverController *popover;

@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)NSArray *shareSource;

@property (nonatomic, assign) NSInteger item;
@property (nonatomic) ShareType shareType;
@property (nonatomic, strong) NSNumber *shareSubType;
@end

@implementation ServiceShareListView


+ (instancetype)viewFromXibWithItemRect:(CGRect)rect Item:(NSInteger)item{
    
    ServiceShareListView *serviceShareView = [[[NSBundle mainBundle] loadNibNamed:@"ServiceShareListView" owner:nil options:nil] lastObject];
    
    serviceShareView.item = item;
    CGRect tableRect;
    
    switch (item) {
        case 0: //top
            tableRect = CGRectMake(rect.origin.x - CGRectGetWidth(rect)/2, CGRectGetMaxY(rect), CGRectGetWidth(rect) * 2,  serviceShareView.dataSource.count * 70);
            break;
        default:
            tableRect = CGRectMake(rect.origin.x, rect.origin.y - serviceShareView.dataSource.count * 70, CGRectGetWidth(rect), serviceShareView.dataSource.count * 70);
            break;
    }
    
    serviceShareView.tableView.frame = tableRect;
    serviceShareView.popTableView.hidden = YES;
    return serviceShareView;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[@[@"WeChat",@"微信"],@[@"Email",@"邮件"]];
    }
    return _dataSource;
}

- (NSArray *)shareSource {
    
    if (!_shareSource) {
        _shareSource = [[PorscheConstant shareConstant] getConstantListHasAllItemAtLastPostionWithTableName:CoreDataPayWay];//@[@"自费",@"保修",@"内结",@"全部"];
    }
    return _shareSource;
}

- (void)showPopoverFromItem:(UIView *)view {
    
    UIPopoverArrowDirection direction = self.item == 0 ?  UIPopoverArrowDirectionRight :UIPopoverArrowDirectionLeft;
    
    [self.popover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:direction animated:YES];
    
}

- (UIPopoverController *)popover {
    
    if (!_popover) {
        _popTableView.hidden = NO;
        _popTableView.frame = CGRectMake(0, 0, 100, 170);
        
        _popover = [AlertViewHelpers getPoperVCWithCustomView:_popTableView popoverContentSize:CGSizeMake(100, 170)];
    }
    return _popover;
}

- (IBAction)closeAction:(id)sender {
    
    [self.popover dismissPopoverAnimated:YES];
    [self removeFromSuperview];
}

#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        return 70;
    } else{
        
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableView == self.tableView ? self.dataSource.count : self.shareSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.popTableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = MAIN_BLUE;
        PorscheConstantModel *constant = [self.shareSource objectAtIndex:indexPath.row];
        cell.textLabel.text = constant.cvvaluedesc;
        cell.textLabel.textAlignment = 1;
        return cell;
    }
    
    ServiceShareListTableViewCell *cell = [ServiceShareListTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageView.image = [UIImage imageNamed:self.dataSource[indexPath.row][0]];
    cell.titleLabel.text = self.dataSource[indexPath.row][1];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.popTableView) {
//        PorscheConstantModel *constant = [self.shareSource objectAtIndex:indexPath.row];
//        self.shareSubType = @(indexPath.row);
//        
//        NSString *smtype = @"";
//        if ([constant.cvsubid integerValue] != 0) {
//            smtype = [constant.cvsubid stringValue];
//        }
//        
//        NSURL *url = [NSURL URLWithString:BASE_URL];
//        NSNumber *port = [url port];
//        
//        NSString *urlstr = [NSString stringWithFormat:@"http://106.14.38.215/ys/porscheweb/views/Porsche_share.html?userid=%@&orderid=%@&smtype=%@&port=%@",[[HDStoreInfoManager shareManager] userid],[[HDStoreInfoManager shareManager] carorderid],smtype,port];
//        
//        if (self.shareType == ShareWechat)
//        {
//            #pragma mark  微信分享权限
//            if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_WeChat]) {
//                return;
//            };
//            [ShareUtil shareWechatParamsByText:@"保时捷感谢您的信任！点击查看报价单" images:@[[UIImage imageNamed:@"share_icon.png"]] url:[NSURL URLWithString:urlstr] title:@"保时捷报价单"];
//        }
//        else if (self.shareType == ShareMail)
//        {
//            #pragma mark  邮件分享权限
//            if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Mail]) {
//                return;
//            };
//            
//            [PorscheRequestManager getPDFFileWithType:PDF_Quotation spareInfo:@[] printCategory:[smtype componentsSeparatedByString:@","] completion:^(NSURL * _Nonnull fileURL) {
//                
//                [ShareUtil shareMailParamsByText:urlstr title:@"保时捷报价单" images:@[[UIImage imageNamed:@"share_icon.png"]] attachments:fileURL recipients:nil ccRecipients:nil bccRecipients:nil];
//                
//            }];
//        }
//        [self.popover dismissPopoverAnimated:YES];
//        [self closeAction:nil];
//        return;
    }
    self.shareType = indexPath.row;
    

    
    if (self.shareType == ShareMail)
    {
#pragma mark  邮件分享权限
        if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Mail]) {
            return;
        }
        
    }
    
    if (self.shareType == ShareWechat)
    {
#pragma mark  微信分享权限
        if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_WeChat]) {
            return;
        };
    }
    [self loadPrintCategorysSelectViewWithPrintType];

//
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    [self showPopoverFromItem:cell];
}
#pragma mark -- 选择分享分类

// 加载打印分类视图
- (void)loadPrintCategorysSelectViewWithPrintType
{
    //    WeakObject(self);
    //    // 高度210
    //    HDSingleSelectView *selectCategoryView = [HDSingleSelectView loadSingleSelectViewWithOrigin:CGPointMake(326, self.view.bounds.size.height - self.bottomView.bounds.size.height - 210)];
    //    selectCategoryView.tag = SelectCategoryViewTag;
    //    selectCategoryView.dataSource = [self configPrintTypeModel];
    //    selectCategoryView.selectFinishedBlock = ^(NSInteger index){
    //        [selfWeak maskViewDidSelectView:nil];
    //    };
    //    self.maskView.hidden = NO;
    //    [self.view addSubview:selectCategoryView];
    
    
    PorschePrintAffirmView *printView = [PorschePrintAffirmView showPrinAffirmViewType:PorschePrintAffirmViewShare complete:^(NSArray *pays, NSInteger count) {
        

//        PorscheConstantModel *constant = [self.shareSource objectAtIndex:indexPath.row];
//        self.shareSubType = @(indexPath.row);
        
        [PorscheRequestManager getWechatShareidCompletion:^(PResponseModel* responser){
            if (responser)
            {
                NSNumber *shareid = [responser.object objectForKey:@"shareid"];
                
                NSString *typeStr = @"";
                if(pays.count)
                {
                    typeStr = [pays componentsJoinedByString:@","];
                }
                
                NSURL *url = [NSURL URLWithString:BASE_URL];
                NSNumber *port = [url port];
                
                HDStoreInfoManager *storeModel = [HDStoreInfoManager shareManager];
                
                NSString *urlstr = [NSString stringWithFormat:@"%@?userid=%@&orderid=%@&smtype=%@&port=%@",[storeModel weburl],[storeModel userid],[storeModel carorderid],typeStr,port];
                
                if (self.shareType == ShareWechat)
                {
#pragma mark  微信分享权限
                    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_WeChat]) {
                        return;
                    };
                    
                    if (!shareid) {
                        shareid = @0;
                    }
                    
                    urlstr = [urlstr stringByAppendingString:[NSString stringWithFormat:@"&shareid=%@",shareid]];
                    [ShareUtil shareWechatParamsByText:@"保时捷感谢您的信任！点击查看报价单" images:@[[UIImage imageNamed:@"share_icon.png"]] url:[NSURL URLWithString:urlstr] title:@"保时捷报价单"];
                }
                else if (self.shareType == ShareMail)
                {
#pragma mark  邮件分享权限
                    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Mail]) {
                        return;
                    };
                    
                    [PorscheRequestManager getPDFFileWithType:PDF_Quotation spareInfo:@[] printCategory:[typeStr componentsSeparatedByString:@","] completion:^(NSURL * _Nonnull fileURL) {
                        
                        [ShareUtil shareMailParamsByText:urlstr title:@"保时捷报价单" images:@[[UIImage imageNamed:@"share_icon.png"]] attachments:fileURL recipients:nil ccRecipients:nil bccRecipients:nil];
                        
                    }];
                }
                [self.popover dismissPopoverAnimated:YES];
                [self closeAction:nil];
            }
        }];
        

    }];
    [HD_FULLView addSubview:printView];
}
@end
