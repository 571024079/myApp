//
//  PorschePhotoGalleryHeaderView.m
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorschePhotoGalleryHeaderView.h"

@implementation PorschePhotoGalleryHeaderView


+ (instancetype)headerWithTableView:(UITableView *)tableView {
    
    static NSString *sectionHeaderId = @"PorschePhotoGalleryHeaderView";
    PorschePhotoGalleryHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderId];
    if (!headerView) {
        headerView = [[[NSBundle mainBundle] loadNibNamed:sectionHeaderId owner:nil options:nil] objectAtIndex:0];
    }
    return headerView;
}
@end
