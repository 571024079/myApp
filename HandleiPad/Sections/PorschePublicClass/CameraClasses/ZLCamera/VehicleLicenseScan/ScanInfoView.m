//
//  ScanInfoView.m
//  CrameraDemo
//
//  Created by Robin on 16/9/23.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "ScanInfoView.h"


#define ScanLineanimateDuration 2.0

@interface ScanInfoView () <ScanInfoTableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIView *infoView;

@property (strong, nonatomic) ScanInfoTableView *scanTableView;

@property (strong, nonatomic) UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIView *topControlBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ScanInfoView {
    
    CGPoint _scantableViewCenter;
    CGPoint _scanPicImageCenter;
    
    //扫描线
    UIImageView *_scanLine;
    CGFloat _scanLineY;
    
//    NSTimer *_lineTimer;

    UILabel *_hintLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScanInfoView" owner:nil options:nil];
        self = [array objectAtIndex:0];
        
        [self createScanView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScanInfoView" owner:nil options:nil];
        self = [array objectAtIndex:0];
        [self createScanView];
    }
    return self;
}

- (void)createScanView {
    
    _picImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 400)];
    _picImage.center = CGPointMake(self.center.x, _picImage.bounds.size.height/2 + 45);
    _scanPicImageCenter = _picImage.center;
    [self insertSubview:_picImage belowSubview:self.topControlBar];
    
    _coverView = [[UIImageView alloc] initWithFrame:_picImage.bounds];
    _coverView.image = [UIImage imageNamed:@"Camera_CardCoverNew"];
    _coverView.backgroundColor = [UIColor clearColor];
    [_picImage addSubview:_coverView];

    [self initScanLine];
    
    [self registerForKeyBoardNotifinations];
}

- (void)initScanInfoViewWithInfo:(NSDictionary *)info {
    
    _scanTableView = [[ScanInfoTableView alloc] initWithFrame:CGRectMake(0, 0, 450, 185)];
    _scanTableView.center = CGPointMake(_picImage.center.x, _picImage.center.y + _picImage.bounds.size.height/2 +_scanTableView.bounds.size.height/2 +10);
    _scanTableView.delegate = self;
    
    NSString *carNum = [info valueForKey:@"plateNo"];
    if (carNum.length > 3) {
        
        _scanTableView.addressLabel.text = [carNum substringToIndex:1];
        _scanTableView.carNumTextFied.text = [carNum substringFromIndex:1];
        _scanTableView.vinTextField.text = [info valueForKey:@"vin"];
    }
    _scantableViewCenter = _scanTableView.center;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView addSubview:_scanTableView];
    
    [self addSubview:scrollView];

}

- (void)setViewType:(ScanInfoViewType)viewType
{
    _viewType = viewType;
    if (viewType == ScanInfoViewTypeVIN)
    {
        _coverView.hidden = YES;
        self.titleLabel.text = @"VIN拍照识别";
    }
    else
    {
        _coverView.hidden = NO;
        self.titleLabel.text = @"行驶证拍照识别";
    }
}
- (void)initScanLine {
    
    _scanLine  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _picImage.bounds.size.width, 2.0)];
    
    _scanLine.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    [self.picImage addSubview:_scanLine];

    _scanLineY = _scanLine.frame.origin.y;
    
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:ScanLineanimateDuration target:self selector:@selector(showLine) userInfo:nil repeats:YES];
    [_lineTimer fire];
}


- (void)showLine {
    
    CGPoint center = _scanLine.center;
    [UIView animateWithDuration:ScanLineanimateDuration animations:^{

        if (center.y < 2) {
            _scanLine.center = CGPointMake(center.x, _picImage.frame.size.height);
        } else {
            _scanLine.center = CGPointMake(center.x, 0);
        }
        
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)showInfo:(NSDictionary *)info {
    
    _scanLine.hidden = YES;
    [_lineTimer invalidate];
    _lineTimer = nil;
    
//    if (![info valueForKey:@"plateNo"]) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"扫描失败" message:@"请重新扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    } else {
//        [self initScanInfoViewWithInfo:info];
//    }
    
    [self initScanInfoViewWithInfo:info];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self scanInfoTableViewCancleClick];
}


//观察键盘

- (void)registerForKeyBoardNotifinations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanViewKeyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanViewKeyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)scanViewKeyBoardShow:(NSNotification *)sender {
    
    NSDictionary* info = [sender userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    CGSize scanTBsize = self.scanTableView.bounds.size;
    CGSize picSize = self.picImage.bounds.size;
    CGRect viewBouns = self.bounds;
    
    if ([self.scanTableView.vinTextField isFirstResponder]) {
        NSLog(@"VIN将显示");

        [UIView animateWithDuration:0.3 animations:^{
            self.scanTableView.center = CGPointMake(_scantableViewCenter.x, viewBouns.size.height - kbSize.height - scanTBsize.height/2);
            
            self.picImage.center = CGPointMake(_scanPicImageCenter.x, viewBouns.size.height - kbSize.height - scanTBsize.height - picSize.height/2 + 100);
        }];
    } else if ([self.scanTableView.carNumTextFied isFirstResponder]) {

        [UIView animateWithDuration:0.3 animations:^{
            self.scanTableView.center = CGPointMake(_scantableViewCenter.x, viewBouns.size.height - kbSize.height - scanTBsize.height/2);

        }];
    }
}

- (void)scanViewKeyBoardHidden:(NSNotification *)sender {
    NSLog(@"键盘将关闭");
    if ([self.scanTableView.vinTextField isFirstResponder]) {
        NSLog(@"VIN将关闭");
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scanTableView.center = _scantableViewCenter;
            
            self.picImage.center = _scanPicImageCenter;
        }];
    } else if ([self.scanTableView.carNumTextFied isFirstResponder]) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.scanTableView.center = _scantableViewCenter;
        }];
    }
    
}

#pragma mark - scanInfoTable代理

- (void)scanInfoTableViewCancleClick {
    
    if (self.scanfinishBlock) {
        self.scanfinishBlock(nil);
    }
}

- (void)scanInfoTableViewConfilrmWidth:(ScanInfoModel *)model {
    
    model.image = self.picImage.image;
    if (self.scanfinishBlock) {
        self.scanfinishBlock(model);
    }

}

- (void)scanInfoTableViewcarCardastralWillShow {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scanTableView.center = CGPointMake(_scantableViewCenter.x, _scantableViewCenter.y - 50);
        
    }];
}

- (void)scanInfoTableViewcarCardastralWillDismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scanTableView.center = _scantableViewCenter;
        
    }];
}
- (IBAction)closeAction:(UIButton *)sender {
    [self scanInfoTableViewCancleClick];
}

- (void)dealloc {

    [self endEditing:YES];
    
    NSLog(@"scanInfoView移除通知中心");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];

}


@end
