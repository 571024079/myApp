//
//  PorschePhotoGalleryHeaderView.h
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PorschePhotoGalleryHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

+ (instancetype)headerWithTableView:(UITableView *)tableView;

@end
