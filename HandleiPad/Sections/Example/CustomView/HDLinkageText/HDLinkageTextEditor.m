//
//  HDLinkageTextEditor.m
//  MutipleAccessView
//
//  Created by Handlecar on 2017/2/17.
//  Copyright © 2017年 handlecar. All rights reserved.
//

#import "HDLinkageTextEditor.h"
#import "LinkageTextField.h"

#define FONTSIZE  11
#define SPACE     0
#define TOP_SPACE 0

@interface HDLinkageTextEditor ()<UITextFieldDelegate,LinkageTextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) UITextField *currentTextField;
@end

@implementation HDLinkageTextEditor


+ (HDLinkageTextEditor *)linkageTextEditorWithTextParts:(NSInteger)parts borderStyle:(UITextBorderStyle)style textLengthLimit:(NSInteger)limitLength frame:(CGRect)frame
{
    HDLinkageTextEditor *editor = [[HDLinkageTextEditor alloc] initWithFrame:frame];
    
    editor.textParts = parts;
    editor.textLengthLimit = limitLength;
    editor.borderStyle = style;
    
    
//    [editor configView];
    
    return editor;
}

- (void)clearContent
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.textFields = nil;

}

- (void)becomeEditWithTexts:(NSArray *)array
{
    
    [self setTextValues:array];
    [[self.textFields firstObject] becomeFirstResponder];
    
//    [textField becomeFirstResponder];
}


- (void)setTextValues:(NSArray *)array
{
    for (NSInteger i = 0; i < self.textFields.count; i++)
    {
        UITextField *textField = [self.textFields objectAtIndex:i];
        textField.text = [array objectAtIndex:i];
    }
}


- (void)configViewWithTextParts:(NSInteger)parts borderStyle:(UITextBorderStyle)style textLengthLimit:(NSInteger)limitLength frame:(CGRect)frame
{
    self.textParts = parts;
    self.textLengthLimit = limitLength;
    
    [self clearContent];
    
    CGFloat textFieldWidth = CGRectGetWidth(self.bounds) / parts;
    self.textFields = [NSMutableArray array];
    for (NSInteger i = 0; i < parts; i++)
    {
        LinkageTextField *textField = [[LinkageTextField alloc] initWithFrame:CGRectMake( i * (textFieldWidth + SPACE), TOP_SPACE, textFieldWidth, CGRectGetHeight(self.bounds) - TOP_SPACE * 2)];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:FONTSIZE];
        textField.delegate = self;
        textField.linkageDelegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.textColor = MAIN_PLACEHOLDER_GRAY;
        
        textField.adjustsFontSizeToFitWidth = YES;
        textField.minimumFontSize = 6;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textField.bounds.size.height)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftView;
        
        [self addSubview:textField];
        [self.textFields addObject:textField];
    }
    
    for (NSInteger i = 0; i < parts - 1; i ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake( (i+1) * (textFieldWidth), 0, 0.5, CGRectGetHeight(self.bounds))];
        line.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:line];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    
    if (currentText.length > self.textLengthLimit)
    {
        // 跳入下一个格子
        UITextField *nextTextField = [self nextTextFieldWithTextField:textField];
        
        if (nextTextField)
        {
            if (nextTextField.text.length >= self.textLengthLimit)
            {
                [nextTextField becomeFirstResponder];
                return NO;
            }
            
            [nextTextField becomeFirstResponder];
            NSRange nextRange = NSMakeRange(nextTextField.text.length, 0);
            BOOL isShould = [self textField:nextTextField shouldChangeCharactersInRange:nextRange replacementString:string];
            if (isShould)
            {
                nextTextField.text = [nextTextField.text stringByReplacingCharactersInRange:nextRange withString:string];
            }
            
        }
        return NO;
    }
    
    return YES;
}

- (UITextField *)nextTextFieldWithTextField:(UITextField *)textField
{
    NSInteger index = [self.textFields indexOfObject:textField];
    if (index + 1 >= self.textFields.count)
    {
        return nil;
    }
    
    UITextField *nextTextField = [self.textFields objectAtIndex:index + 1];
    return nextTextField;
}

- (LinkageTextField *)upperTextFieldWithTextField:(UITextField *)textField
{
    NSInteger index = [self.textFields indexOfObject:textField];
    if (index - 1 < 0)
    {
        return nil;
    }
    
    LinkageTextField *upperTextField = [self.textFields objectAtIndex:index - 1];
    return upperTextField;
}

- (void)keyBoardDeleteBackward:(LinkageTextField *)textField
{
    if (!textField.text.length)
    {
        // 寻找上一个 进入编辑状态
        LinkageTextField *upperTextField = [self upperTextFieldWithTextField:textField];
        [upperTextField becomeFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(linkageTextEditor:didEndEditTextField:atIndex:)])
    {
        NSInteger index = [self.textFields indexOfObject:textField];
        [self.delegate linkageTextEditor:self didEndEditTextField:textField atIndex:index];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(linkageTextEditor:didDoneEditTextField:)])
    {
        NSArray *texts = [self.textFields valueForKey:@"text"];
        [self.delegate linkageTextEditor:self didDoneEditTextField:texts];
    }
    
    return YES;
}

@end
