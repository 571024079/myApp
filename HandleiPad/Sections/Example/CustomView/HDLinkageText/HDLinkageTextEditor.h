//
//  HDLinkageTextEditor.h
//  MutipleAccessView
//
//  Created by Handlecar on 2017/2/17.
//  Copyright © 2017年 handlecar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDLinkageTextEditor;

@protocol HDLinkageTextEditorDelegate <NSObject>

- (void)linkageTextEditor:(HDLinkageTextEditor *)editor didDoneEditTextField:(NSArray *)texts;
- (void)linkageTextEditor:(HDLinkageTextEditor *)editor didEndEditTextField:(UITextField *)textField atIndex:(NSInteger)index;

@end

@interface HDLinkageTextEditor : UIView

@property (nonatomic) NSInteger textParts; // 文本框个数
@property (nonatomic) NSInteger textLengthLimit; // 文本长度限制

@property (nonatomic) UITextBorderStyle borderStyle; // 文本框样式
@property (nonatomic, weak) id<HDLinkageTextEditorDelegate>delegate;
+ (HDLinkageTextEditor *)linkageTextEditorWithTextParts:(NSInteger)parts borderStyle:(UITextBorderStyle)style textLengthLimit:(NSInteger)limitLength frame:(CGRect)frame;
- (void)configViewWithTextParts:(NSInteger)parts borderStyle:(UITextBorderStyle)style textLengthLimit:(NSInteger)limitLength frame:(CGRect)frame;
- (void)becomeEditWithTexts:(NSArray *)array;
- (void)setTextValues:(NSArray *)array;
- (void)setBorderColor:(UIColor *)color;
@end
