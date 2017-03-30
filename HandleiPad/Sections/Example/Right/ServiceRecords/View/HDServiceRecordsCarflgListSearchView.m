//
//  HDServiceRecordsCarflgListSearchView.m
//  HandleiPad
//
//  Created by handlecar on 16/12/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRecordsCarflgListSearchView.h"

@interface HDServiceRecordsCarflgListSearchView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HDServiceRecordsCarflgListSearchView
- (void)awakeFromNib {
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
}



#pragma mark - 车辆标签界面显示
- (void)setCarflgSearchList:(NSMutableArray *)carflgSearchList {
    _carflgSearchList = carflgSearchList;
    
    //设置提示框是否显示
    if (_carflgSearchList.count) {
        self.hidden = NO;
        
        CGRect frame = self.frame;
        
        CGFloat height = 24.0 * _carflgSearchList.count;
        if (height > 150) {
            height = 150;
        }
        frame.size.height = height;
        self.frame = frame;

        [self.tableView reloadData];
    }else {
        self.hidden = YES;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carflgSearchList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDServiceRecordsCarflgListSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carflgSearchCell"];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRecordsCarflgListSearchView" owner:self options:nil] objectAtIndex:1];
    }
    
    
    HDServiceRecordsCarflgTableViewModel *model = _carflgSearchList[indexPath.row];
    cell.contentLabel.text = model.targetname;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObject(self)
    HDServiceRecordsCarflgTableViewModel *model = _carflgSearchList[indexPath.row];
    if (selfWeak.selectCellBlock) {
        selfWeak.selectCellBlock(model);
    }
}



@end









@implementation HDServiceRecordsCarflgListSearchViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
