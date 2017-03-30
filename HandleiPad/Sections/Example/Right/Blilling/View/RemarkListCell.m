//
//  RemarkListCell.m
//  HandleiPad
//
//  Created by Handlecar on 10/21/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "RemarkListCell.h"
@interface RemarkListCell()<UITextViewDelegate>

@end
@implementation RemarkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.remarkTextView.contentInset = UIEdgeInsetsZero;
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.remarkTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);
    self.remarkTextView.delegate = self;
    self.remarkTextView.returnKeyType = UIReturnKeyDone;
//    self.remarkTextView.contentMode = UIViewContentModeTop | UIViewContentModeLeft;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.remarkTextView.contentOffset = CGPointZero;
//    });
//    self.remarkTextView.userInteractionEnabled = NO;
}

- (void)remarkShouldEidt:(BOOL)ret
{
    self.editButton.hidden = !ret;
    self.remarkTextView.userInteractionEnabled = ret;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.remarkTextView scrollRangeToVisible:NSMakeRange(self.remarkTextView.text.length, 1)];
    if ([self.delegate respondsToSelector:@selector(remarkCell:textViewDidBeginEditing:)])
    {
        [self.delegate remarkCell:self textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(remarkCell:textViewDidEndEditing:)])
    {
        [self.delegate remarkCell:self textViewDidEndEditing:textView];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (IBAction)editbuttonAction:(id)sender {
//    self.remarkTextView.userInteractionEnabled = YES;
    [self.remarkTextView becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
