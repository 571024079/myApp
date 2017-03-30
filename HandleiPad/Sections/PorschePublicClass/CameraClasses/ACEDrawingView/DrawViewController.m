//
//  DrawViewController.m
//  DrawImageViewDemo
//
//  Created by GoodRobin on 16/9/21.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawOptionsViewController.h"
#import "ACEDrawingTools.h"

#define ToolBarHeight           217.f



@interface DrawViewController () <ACEDrawingViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *coversButton;
@property (weak, nonatomic) IBOutlet UIButton *rectTool;
@property (weak, nonatomic) IBOutlet UIButton *ellipseTool;
@property (weak, nonatomic) IBOutlet UIButton *arrowTool;
@property (weak, nonatomic) IBOutlet ACEDrawingView *drawingView;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UITextField *markTextField;
@property (weak, nonatomic) IBOutlet UITextField *baseTextField;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *colorButton1;
@property (weak, nonatomic) IBOutlet UIButton *colorButton2;
@property (weak, nonatomic) IBOutlet UIButton *colorButton3;
@property (weak, nonatomic) IBOutlet UIButton *colorButton4;
@property (weak, nonatomic) IBOutlet UIButton *colorButton5;
@property (weak, nonatomic) IBOutlet UIButton *colorButton6;
@property (weak, nonatomic) IBOutlet UIButton *colorButton7;

@property (nonatomic, strong) UIButton *bigColorButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drawBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drawTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeight;

//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *lastToolButton;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) UIButton *lastColorButton;
@property (nonatomic, strong) UIView *clearView;

@end

@implementation DrawViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.toolBarHeight.constant = ToolBarHeight/[UIScreen mainScreen].scale;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupConfiguration];

//    rectTool
//    ellipseTool
//    arrowTool
    
    self.bigColorButton.center = CGPointMake(self.view.bounds.size.width - 35, ToolBarHeight/[UIScreen mainScreen].scale/2);
    [self.colorButton1.superview insertSubview:self.bigColorButton belowSubview:self.colorButton1];
    

    
    [self updateButtonStatus];
}

- (void)setupConfiguration {
    
    self.drawingView.lineColor = [UIColor redColor];
    self.drawingView.lineWidth = 4;
    self.drawingView.delegate = self;
    self.drawingView.draggableTextFontName = @"MarkerFelt-Thin";
    self.drawingView.showDeleteButton = YES;
    
    self.bigColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bigColorButton.frame = CGRectMake(0, 0, 50, 50);
    self.bigColorButton.layer.borderWidth = 2;
    self.bigColorButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (self.imageUrl.absoluteString.length)
    {
        WeakObject(self);
        [self.picImageView sd_setImageWithURL:self.imageUrl placeholderImage:[UIImage imageNamed:PlaceHolderImageNormalName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error)
            {
                if (selfWeak.pathArray) {
                    [selfWeak.drawingView drawWithPaths:self.pathArray];
                }
            }
        }];
//        [self.picImageView sd_setImageWithURL:self.imageUrl];
    }
    else
    {
        if (self.pathArray) {
            [self.drawingView drawWithPaths:self.pathArray];
        }
        self.picImageView.image = self.image;
    }

    self.markTextField.text = self.markString;
    
    
    [self setupColorbutton];

    //设置工具按钮的选中按钮
    [self setButtonSelectdImage:self.rectTool];
    [self setButtonSelectdImage:self.ellipseTool];
    [self setButtonSelectdImage:self.arrowTool];
    [self setButtonSelectdImage:self.coversButton];
    
    // 设置封面是否选中
    self.coversButton.selected = self.isCovers;
    
    //设置默认选中
    [self changeEllipseTool:self.ellipseTool];
    [self colorAction:self.colorButton1];

    //设置textField代理
    self.markTextField.delegate = self;
}

- (UIView *)clearView {
    
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:self.view.bounds];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _clearView.bounds;
        [button addTarget:self action:@selector(closeKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        [_clearView addSubview:button];
    }
    return _clearView;
}

- (void)setButtonSelectdImage:(UIButton *)button {
    
    UIImage *image = button.imageView.image;
    
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    button.tintColor = [UIColor grayColor];
}

- (void)setupColorbutton {
    
    for (int i = 0; i < 7; i++) {
        UIButton *colorBtn = [self.view viewWithTag:3000+i];
        [colorBtn setBackgroundColor:self.colorArray[i]];
    }
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (NSArray *)colorArray {
    
    if (!_colorArray) {
        _colorArray = @[Color(255, 207, 70),Color(42, 75, 709),Color(45, 35, 215),Color(113, 197, 242),Color(204, 0, 0),Color(255, 255, 255),Color(0, 0, 0)];
    }
    
    return _colorArray;
}

#pragma mark - 选择工具

- (IBAction)setCoversAction:(id)sender {
    
    self.coversButton.selected = !self.coversButton.selected;
    
}

- (IBAction)changeRectTool:(UIButton *)sender {
    
    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
    [self changeButtonStaus:sender];
    
//    DrawOptionsViewController *optionVC = [[DrawOptionsViewController alloc] init];
//    
//    optionVC.modalPresentationStyle = UIModalPresentationPopover;
//    optionVC.popoverPresentationController.sourceView = sender;
//    optionVC.popoverPresentationController.sourceRect = sender.bounds;
//    optionVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
//    optionVC.popoverPresentationController.delegate = self;
//    optionVC.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 64);
//    [self presentViewController:optionVC animated:YES completion:nil];
}
- (IBAction)changeEllipseTool:(UIButton *)sender {
    
    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
    [self changeButtonStaus:sender];
}
- (IBAction)changeArrowTool:(UIButton *)sender {
    
    self.drawingView.drawTool = ACEDrawingToolTypeArrow;
    [self changeButtonStaus:sender];
}

- (void)changeButtonStaus:(UIButton *)sender {
    
    if (sender.selected == YES) {
        return;
    }
    sender.selected = YES;
    self.lastToolButton.selected = NO;
    self.lastToolButton = sender;
}

#pragma mark - 撤销&向前
- (IBAction)undoAction:(UIButton *)sender {
    
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}
- (IBAction)redoAction:(UIButton *)sender {
    
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

#pragma mark - 删除&完成
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)deleteAction:(UIButton *)sender {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)doneAction:(UIButton *)sender {
    
//    [self.picImageView removeFromSuperview];

//    CGRect originalImageRect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
//    self.basicView.frame = originalImageRect;
//    
//    for (UIButton *view in self.drawingView.subviews) {
//        [view removeFromSuperview];
//    }
//    
//    //新建原始图图层
//    UIImageView *originalPIC = [[UIImageView alloc] initWithImage:self.image];
//    originalPIC.center = self.basicView.center;
//    [self.basicView addSubview:originalPIC];
//    [self.basicView insertSubview:originalPIC belowSubview:self.drawingView];
//    
//    //修改DrawView的约束与原始图一致
//    self.drawBottom.constant = self.view.bounds.size.height - self.image.size.height;
//    self.drawTrailing.constant = self.view.bounds.size.width - self.image.size.width;
//
//    //开始画画
//    UIGraphicsBeginImageContextWithOptions(self.basicView.bounds.size, YES, 1.0);
//    [self.basicView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    // 保存到本地
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    // scale drawings to size of base image
    UIImage *drawings = [self drawings];
    UIImage *baseImage = self.picImageView.image;
    drawings = (baseImage.size.width > baseImage.size.height) ? [self scaleImage:drawings proportionallyToWidth:baseImage.size.width] : [self scaleImage:drawings proportionallyToHeight:baseImage.size.height];
    
    // blend drawings with image
    UIImage *image = [self blendImage:self.picImageView.image topImage:drawings];

    if (self.doneBlock) {
        NSString *mark = [self.markTextField.text copy];
        self.doneBlock(image,mark,self.coversButton.selected, [self.drawingView.pathArray copy]);
    }
    [self dismissViewControllerAnimated:NO completion:^{
    }];
   }
//- (void)tapSaveImageToIphone{
//    
//    /**
//     *  将图片保存到iPhone本地相册
//     *  UIImage *image            图片对象
//     *  id completionTarget       响应方法对象
//     *  SEL completionSelector    方法
//     *  void *contextInfo
//     */
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    
//}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
//    if (error == nil) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",  nil];
//        [alert show];
//        
//    }else{
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
    
}
- (UIImage *)drawings
{
    if (self.drawingView.pathArray.count == 0)
        return nil;
    
    UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, NO, 0.0);
    for (id<ACEDrawingTool> tool in self.drawingView.pathArray) {
        [tool draw];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage*)scaleImage:(UIImage *)sourceImage proportionallyToWidth:(CGFloat)width
{
    UIImage *newImage = nil;
    CGFloat height = sourceImage.size.height * (width / sourceImage.size.width);
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0, 0, width, height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaleImage:(UIImage *)sourceImage proportionallyToHeight:(CGFloat)height
{
    UIImage *newImage = nil;
    CGFloat width = sourceImage.size.width * (height / sourceImage.size.height);
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0, 0, width, height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
// if blending results in memory issues, please scale down the size of images before blending
- (UIImage *)blendImage:(UIImage *)imageBottom topImage:(UIImage *)imageTop
{
    UIImage *image;
    UIGraphicsBeginImageContext(imageBottom.size);
    [imageBottom drawAtPoint:CGPointZero];
    [imageTop drawAtPoint:CGPointZero];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (IBAction)colorAction:(UIButton *)sender {
    
    NSInteger colorIndex = sender.tag - 3000;
    
    self.drawingView.lineColor = self.colorArray[colorIndex];

    self.bigColorButton.center = sender.center;
    self.bigColorButton.backgroundColor = self.colorArray[colorIndex];
    [sender.superview insertSubview:self.bigColorButton belowSubview:sender];
    
    self.lastColorButton = sender;
}
- (IBAction)markAction:(id)sender {
    
    [self.markTextField becomeFirstResponder];

//    self.markTextField.hidden = !self.markTextField.hidden;
//    self.baseTextField.hidden = self.markTextField.hidden;
//    
//    if (!self.markTextField.hidden) {
//        [self.markTextField becomeFirstResponder];
//    } else{
//        [self.markTextField resignFirstResponder];
//    }
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool
{
    [self updateButtonStatus];
}

- (void)drawingViewDidDeleteDraw:(ACEDrawingView *)view {
    
    [self updateButtonStatus];
}

//- (BOOL)shouldAutorotate {
//    
//    CGSize size = self.image.size;
//    return size.width > size.height ? YES : NO;
//}

// 画面一开始加载时就根据图片尺寸选择显示方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    
//    CGSize size = self.image.size;
//    
//    return size.width > size.height ? interfaceOrientation : UIInterfaceOrientationPortrait;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self closeKeyBoard];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.view insertSubview:self.clearView belowSubview:self.topBarView];
}

- (void)closeKeyBoard {
    
    if (self.clearView.superview) {
        [self.clearView removeFromSuperview];
    }
    [self.view endEditing:YES];
}

- (void)dealloc {
    
    NSLog(@"图片编辑页面被释放");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
