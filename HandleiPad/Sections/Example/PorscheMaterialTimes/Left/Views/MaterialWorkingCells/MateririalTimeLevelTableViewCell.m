//
//  MateririalTimeLevelTableViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MateririalTimeLevelTableViewCell.h"


#define FontColor [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]

@interface MateririalTimeLevelTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *noClassItem;
@property (weak, nonatomic) IBOutlet UIView *safeItem;
@property (weak, nonatomic) IBOutlet UIView *infoItem;
@property (weak, nonatomic) IBOutlet UIView *troubleItem;

@property (weak, nonatomic) IBOutlet UIImageView *noClassImageView;
@property (weak, nonatomic) IBOutlet UIImageView *noClassBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *noClassLabel;


@property (weak, nonatomic) IBOutlet UIImageView *safeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *safeBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *safaLabel;


@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property (weak, nonatomic) IBOutlet UIImageView *troubleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *troubleBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *troubleLabel;

@end

@implementation MateririalTimeLevelTableViewCell {
    
    UIImageView *_lastImageView;
    UIImageView *_lastBackImageView;
    UILabel *_lastLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MateririalTimeLevelTableViewCell" owner:nil options:nil];
//        self = [array objectAtIndex:0];
//        
//        [self setShandow];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _lastBackImageView = _noClassBackImageView;
//    _lastImageView = _noClassImageView;
//    _lastLabel = _noClassLabel;
    
    [self setShandow];
}

- (void)setShandow {
    
    _noClassItem.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    _noClassItem.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _noClassItem.layer.cornerRadius = 4;
    
    _safeItem.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    _safeItem.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _safeItem.layer.cornerRadius = 4;
    
    _infoItem.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    _infoItem.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _infoItem.layer.cornerRadius = 4;
    
    _troubleItem.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    _troubleItem.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _troubleItem.layer.cornerRadius = 4;
}
- (IBAction)noClassAction:(id)sender {
    
    [self reductionItem];
    
    if (_lastImageView == _noClassImageView) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(0)];
        self.levelStyle = 0;
        _lastBackImageView = nil;
        _lastImageView = nil;
        _lastLabel =nil;
        return;
    };
    
    PorscheSchemeLevelStyle catory = PorscheSchemeLevelStyleCustom;
    self.levelStyle = catory;
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(catory)];
    _lastBackImageView = _noClassBackImageView;
    _lastImageView = _noClassImageView;
    _lastLabel = _noClassLabel;
    
    [PorscheRequestSchemeListModel shareModel].schemelevelid = 0;
    [self setSelectedBackImageView:_noClassBackImageView titleLabel:_noClassLabel];
}

- (IBAction)safeAction:(id)sender {
    
    [self reductionItem];
    
    if (_lastImageView == _safeImageView) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(0)];
        self.levelStyle = 0;
        _lastBackImageView = nil;
        _lastImageView = nil;
        _lastLabel =nil;
        return;
    };

    PorscheSchemeLevelStyle catory = PorscheSchemeLevelStyleSave;
    self.levelStyle = catory;
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(catory)];
    _lastBackImageView = _safeBackImageView;
    _lastImageView = _safeImageView;
    _lastLabel = _safaLabel;
    
    [self setSelectedBackImageView:_safeBackImageView titleLabel:_safaLabel];
    
    [PorscheRequestSchemeListModel shareModel].schemelevelid = @(1);
}

- (IBAction)infoAction:(id)sender {
    
    [self reductionItem];
    
    if (_lastImageView == _infoImageView) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(0)];
        self.levelStyle = 0;
        _lastBackImageView = nil;
        _lastImageView = nil;
        _lastLabel =nil;
        return;
    };
    
    PorscheSchemeLevelStyle catory = PorscheSchemeLevelStyleMessage;
    self.levelStyle = catory;
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(catory)];
    _lastBackImageView = _infoBackImageView;
    _lastImageView = _infoImageView;
    _lastLabel = _infoLabel;
    
    [self setSelectedBackImageView:_infoBackImageView titleLabel:_infoLabel];
    
    [PorscheRequestSchemeListModel shareModel].schemelevelid = @(2);
}
- (IBAction)troubleAction:(id)sender {
    
    [self reductionItem];
    
    if (_lastImageView == _troubleImageView) {
        
         [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(0)];
        self.levelStyle = 0;
        _lastBackImageView = nil;
        _lastImageView = nil;
        _lastLabel =nil;
        return;
    };
    
    PorscheSchemeLevelStyle catory = PorscheSchemeLevelStyleHiddenDanger;
    self.levelStyle = catory;
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_LEVEL_NOTIFICATION object:@(catory)];
    _lastBackImageView = _troubleBackImageView;
    _lastImageView = _troubleImageView;
    _lastLabel = _troubleLabel;
    
    [self setSelectedBackImageView:_troubleBackImageView titleLabel:_troubleLabel];
    
    [PorscheRequestSchemeListModel shareModel].schemelevelid = @(3);
}

- (void)reductionItem {
    
    _lastBackImageView.image = nil;
    _lastLabel.textColor = FontColor;
    
    if (_lastBackImageView == _safeBackImageView) {
        
        _safeImageView.image = [UIImage imageNamed:@"materialtime_list_safe_normal"];
        _safeBackImageView.image = nil;
    } else if (_lastBackImageView == _infoBackImageView) {
        
        _infoImageView.image = [UIImage imageNamed:@"materialtime_list_info_normal.png"];
        _infoBackImageView.image = nil;
    } else if (_lastBackImageView == _troubleBackImageView) {
        
        _troubleImageView.image = [UIImage imageNamed:@"materialtime_list_trouble_normal"];
        _troubleBackImageView.image = nil;
    } else if (_lastBackImageView == _noClassBackImageView) {
        
        _noClassImageView.image = [UIImage imageNamed:@"materialtime_list_noClass_normal"];
        _noClassBackImageView.image = nil;
    }
}

- (void)setSelectedBackImageView:(UIImageView *)backImageView titleLabel:(UILabel *)titleLabel {
    
    backImageView.image = [UIImage imageNamed:@"hd_work_list_clean"];
    titleLabel.textColor = [UIColor whiteColor];

    if (_lastImageView == _safeImageView) {
        
        _safeImageView.image = [UIImage imageNamed:@"materialtime_list_safe_selected"];
        _lastImageView = _safeImageView;
        
    } else if (_lastImageView == _infoImageView) {
        
        _infoImageView.image = [UIImage imageNamed:@"materialtime_list_info_selected"];
        
        _lastImageView = _infoImageView;
        
    } else if (_lastImageView == _troubleImageView) {
        
        _troubleImageView.image = [UIImage imageNamed:@"materialtime_list_trouble_selected"];
        
        _lastImageView = _troubleImageView;
        
    }else if (_lastImageView == _noClassImageView) {
        
        _noClassImageView.image = [UIImage imageNamed:@"materialtime_list_noClass_selected"];
        
        _lastImageView = _noClassImageView;
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
