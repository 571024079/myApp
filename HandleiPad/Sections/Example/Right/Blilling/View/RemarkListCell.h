//
//  RemarkListCell.h
//  HandleiPad
//
//  Created by Handlecar on 10/21/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemarkListCell;
@protocol RemarkListCellDelegate <NSObject>

- (void)remarkCell:(RemarkListCell *)cell  textViewDidBeginEditing:(UITextView *)textView;
- (void)remarkCell:(RemarkListCell *)cell  textViewDidEndEditing:(UITextView *)textView;


@end

@interface RemarkListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *someOneSayLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *remarkTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) id<RemarkListCellDelegate>delegate;

- (void)remarkShouldEidt:(BOOL)ret;

@end
