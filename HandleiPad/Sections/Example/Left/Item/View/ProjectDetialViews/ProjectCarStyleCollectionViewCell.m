//
//  ProjectCarStyleCollectionViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectCarStyleCollectionViewCell.h"

@interface ProjectCarStyleCollectionViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageviewWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteWidthLayout;

@end

@implementation ProjectCarStyleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    
    self.layer.cornerRadius = 3;
    
    _imageviewWidthLayout.constant = 0;
    _deleteWidthLayout.constant = 0;
}

- (void)setEditCell:(BOOL)editCell {
    
    _editCell = editCell;
    
    if (editCell) {
        _imageviewWidthLayout.constant = 20;
        _deleteWidthLayout.constant = 20;
    } else {
        _imageviewWidthLayout.constant = 0;
        _deleteWidthLayout.constant = 0;
    }
}
- (IBAction)deleteAction:(id)sender {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
