//
//  HDClientTableViewHeaderView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDClientTableViewHeaderView : UITableViewHeaderFooterView


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *headerLb;

@property (weak, nonatomic) IBOutlet UILabel *sureLb;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (nonatomic, strong) PorscheNewScheme *tmpModel;

@end
