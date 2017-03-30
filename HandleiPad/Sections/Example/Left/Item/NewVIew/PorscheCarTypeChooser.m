//
//  PorscheCarTypeChooser.m
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheCarTypeChooser.h"
#import "PorscheCustomModel.h"
#import "PorscheCartypeChooserCell.h"
#import "PorscheMultipleListhView.h"

@interface PorscheCarTypeChooser () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *chooserView;
@property (weak, nonatomic) IBOutlet UITableView *carSeriesTableView;
@property (weak, nonatomic) IBOutlet UITableView *carTypeTableView;
@property (weak, nonatomic) IBOutlet UITableView *carYearTableView;
@property (weak, nonatomic) IBOutlet UITableView *carDispTableView;

@property (weak, nonatomic) IBOutlet UIView *carSeriesView;
@property (weak, nonatomic) IBOutlet UIView *carTypeView;
@property (weak, nonatomic) IBOutlet UIView *carYearView;
@property (weak, nonatomic) IBOutlet UIView *carDispView;

@property (nonatomic, strong) NSMutableArray *carSeriesTableViewSource;
@property (nonatomic, strong) NSMutableArray *carTypeTableViewSource;
@property (nonatomic, strong) NSArray *carYearTableViewSource;
@property (nonatomic, strong) NSArray *carDispTableViewSource;

@property (nonatomic, strong) NSMutableArray *cars; //车型

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *listDatas;
@property (nonatomic, strong) NSMutableArray *oneArray;

@property (weak, nonatomic) IBOutlet UIImageView *seriesBotoomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *seriesUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *typeUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *typeBotoomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *yearUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *yearBotoomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dispUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dispBottomArrow;

@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation PorscheCarTypeChooser {
    
    NSArray *_nextSelecs;
    
    NSArray *_selecs;
    
    NSString *_lastTitle;
    
    UITableView *_lastTableView;
}


+ (instancetype)viewWithXib {

    PorscheCarTypeChooser *chooser = [[[NSBundle mainBundle] loadNibNamed:@"PorscheCarTypeChooser" owner:nil options:nil] lastObject];
    
    [chooser.carSeriesTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carSeriesTableView"];
    [chooser.carTypeTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carTypeTableView"];
    [chooser.carYearTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carYearTableView"];
    [chooser.carDispTableView registerNib:[UINib nibWithNibName:@"PorscheCartypeChooserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"carDispTableView"];
    
    chooser.carSeriesTableView.tableFooterView = [UIView new];
    chooser.carTypeTableView.tableFooterView = [UIView new];
    chooser.carYearTableView.tableFooterView = [UIView new];
    chooser.carDispTableView.tableFooterView = [UIView new];
    
    return chooser;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (NSArray *)tableViews {
    
    if (!_tableViews) {

        _tableViews = @[self.carSeriesTableView,self.carTypeTableView,self.carYearTableView,self.carDispTableView];
    }
    return _tableViews;
}

- (NSMutableArray *)cars {
    
    if (!_cars) {
        _cars = [[NSMutableArray alloc] init];
    }
    return _cars;
}

- (NSMutableArray *)oneArray {
    
    if (!_oneArray) {
        _oneArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    }
    
    return _oneArray;
}

- (NSMutableArray *)listDatas {
    
    if (!_listDatas) {
        _listDatas = [[NSMutableArray alloc] init];
        
        [_listDatas addObject:self.dataDic];
        for (NSInteger i =0; i < 4; i ++) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [_listDatas addObject:dic];
        }
    }
    return _listDatas;
}

- (NSMutableDictionary *)dataDic {
    
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}

- (NSMutableArray *)carSeriesTableViewSource {
    
    if (!_carSeriesTableViewSource) {
        _carSeriesTableViewSource = [[NSMutableArray alloc] init];
        [_carSeriesTableViewSource addObjectsFromArray:[PorscheCustomModel getAllPorsheCarSeries]];
        [_carSeriesTableViewSource insertObject:@"全部车系" atIndex:0];
    }
    return _carSeriesTableViewSource;
}

- (NSMutableArray *)carTypeTableViewSource {

    if (!_carTypeTableViewSource) {
        _carTypeTableViewSource = [[NSMutableArray alloc] init];
    }
    return _carTypeTableViewSource;
}

- (NSArray *)carYearTableViewSource {
    
    if (!_carYearTableViewSource) {
        _carYearTableViewSource = @[@"全部年款",@"2012款",@"2013款",@"2014款",@"2015款",@"2016款"];
    }
    return _carYearTableViewSource;
}

- (NSArray *)carDispTableViewSource {
    
    if (!_carDispTableViewSource) {
        _carDispTableViewSource = @[@"全部排量",@"2.0",@"2.2",@"2.4",@"2.6",@"2.8",@"3.0",@"3.2",@"3.4"];
    }
    return _carDispTableViewSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.carSeriesTableView) {
        return self.carSeriesTableViewSource.count;
    }
    if (tableView == self.carTypeTableView) {
        return self.carTypeTableViewSource.count;
    }
    if (tableView == self.carYearTableView) {
        return self.carYearTableViewSource.count;
    }
    if (tableView == self.carDispTableView) {
        return self.carDispTableViewSource.count;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    NSString *title;
    if (tableView == self.carSeriesTableView) {
        identifier = @"carSeriesTableView";
        title = self.carSeriesTableViewSource[indexPath.row];
    }
    if (tableView == self.carTypeTableView) {
        identifier = @"carTypeTableView";
        title = self.carTypeTableViewSource[indexPath.row];
    }
    if (tableView == self.carYearTableView) {
        identifier = @"carYearTableView";
        title = self.carYearTableViewSource[indexPath.row];
    }
    if (tableView == self.carDispTableView) {
        identifier = @"carDispTableView";
        title = self.carDispTableViewSource[indexPath.row];
    }
    
    PorscheCartypeChooserCell *cell = [PorscheCartypeChooserCell cellWithTableView:tableView identifer:identifier];
    cell.titleLabel.text = title;

    cell.multipleCell = self.multipleChoice;
    if ([_nextSelecs containsObject:title]) {
        cell.cellSelected = YES;
    } else {
        cell.cellSelected = NO;
    }
    
    [self refreshArrow:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PorscheCartypeChooserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.titleLabel.text;
    
    NSInteger tableViewIndex = tableView.tag - 6000;

    if (self.multipleChoice) { //多选
        
        NSMutableDictionary *tableDic = [self.listDatas objectAtIndex:tableViewIndex];
        
        
        
        if ([tableDic.allKeys containsObject:title]) {
            
            if ([_lastTitle isEqualToString:title] && _lastTableView == tableView) {
                cell.cellSelected = NO;
                [tableDic removeObjectForKey:title];
                
                _nextSelecs = nil;
                _lastTitle = nil;
                
            } else {
                _nextSelecs = [[[tableDic objectForKey:title] allKeys] copy];
                _lastTitle = title;
                NSMutableDictionary *dic = [tableDic objectForKey:title];
                [self.listDatas replaceObjectAtIndex:tableViewIndex + 1 withObject:dic];
            }
            
        } else {
            cell.cellSelected = YES;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [tableDic setObject:dic forKey:title];
            [self.listDatas replaceObjectAtIndex:tableViewIndex + 1 withObject:dic];
            _nextSelecs = nil;
            _lastTitle = title;
        }
        
        _lastTableView = tableView;
        
        
    }
    
    else { //单选
        cell.cellSelected = !cell.cellSelected;
        
        _lastTitle = title;
        if (!cell.cellSelected) {
            [self.oneArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (idx > tableViewIndex) [self.oneArray replaceObjectAtIndex:tableViewIndex withObject:@""];
            }];
        } else {
            [self.oneArray replaceObjectAtIndex:tableViewIndex withObject:title];
        }

    }
    
    if (tableView == self.carSeriesTableView) {
        
        self.carTypeTableView.hidden = indexPath.row == 0 || !_lastTitle;
        self.carYearTableView.hidden = YES;
        self.carDispTableView.hidden = YES;
        [self.carTypeTableViewSource removeAllObjects];
        [self.carTypeTableViewSource addObjectsFromArray:[PorscheCustomModel getCarypeWithCarSeries:title]];
        [self.carTypeTableViewSource insertObject:@"全部车型" atIndex:0];
//        self.carYearTableViewSource = nil;
//        self.carDispTableViewSource = nil;
        [self.carTypeTableView reloadData];
        [self.carYearTableView reloadData];
        [self.carDispTableView reloadData];
    }
    if (tableView == self.carTypeTableView) {
        
        self.carYearTableView.hidden = indexPath.row == 0 || !_lastTitle;
        self.carDispTableView.hidden = YES;
//        self.carYearTableViewSource = indexPath.row == 0 ? nil: @[@"全部年款",@"2012款",@"2013款",@"2014款",@"2015款",@"2016款"];
//        self.carDispTableViewSource = nil;
        [self.carYearTableView reloadData];
        [self.carDispTableView reloadData];
    }
    if (tableView == self.carYearTableView) {
        
        self.carDispTableView.hidden = indexPath.row == 0 || !_lastTitle;
//        self.carDispTableViewSource =indexPath.row == 0 ? nil: @[@"全部排量",@"2.0",@"2.2",@"2.4",@"2.6",@"2.8",@"3.0",@"3.2",@"3.4"];
        [self.carDispTableView reloadData];
    }
    if (tableView == self.carDispTableView) {
        
    }
    
    NSLog(@"%@",self.dataDic);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UITableView *tableView = (UITableView *)scrollView;
    
    [self refreshArrow:tableView];
    
   }

- (void)refreshArrow:(UITableView *)tableView {
    
    NSInteger topRow = [tableView.indexPathsForVisibleRows firstObject].row;
    NSInteger botoomRow = [tableView.indexPathsForVisibleRows lastObject].row;
    
    if (tableView == self.carSeriesTableView) {
        
        _seriesUpArrow.hidden = topRow==0;
        _seriesBotoomArrow.hidden = botoomRow == self.carSeriesTableViewSource.count - 1;
        
        if (self.carSeriesTableView.hidden) {
            _seriesUpArrow.hidden = YES;
            _seriesBotoomArrow.hidden = YES;
        }
        
    } else if (tableView == self.carTypeTableView) {
        
        _typeUpArrow.hidden = topRow==0;
        _typeBotoomArrow.hidden = botoomRow == self.carTypeTableViewSource.count - 1;
        if (self.carTypeTableView.hidden) {
            _typeUpArrow.hidden = YES;
            _typeBotoomArrow.hidden = YES;
        }

    } else if (tableView == self.carYearTableView) {
        
        _yearUpArrow.hidden = topRow==0;
        _yearBotoomArrow.hidden = botoomRow == self.carYearTableViewSource.count - 1;
        
        if (self.carYearTableView.hidden) {
            _yearUpArrow.hidden = YES;
            _yearBotoomArrow.hidden = YES;
        }
    } else if (tableView == self.carDispTableView) {
        
        _dispUpArrow.hidden = topRow==0;
        _dispBottomArrow.hidden = botoomRow == self.carDispTableViewSource.count - 1;
        
        if (self.carDispTableView.hidden) {
            _dispUpArrow.hidden = YES;
            _dispBottomArrow.hidden = YES;
        }
    }
}
- (IBAction)confirmAction:(id)sender {
    
    if (self.saveBlcok) {
        
        if (self.multipleChoice) {
            [self.cars removeAllObjects];
            NSArray *carArray = [self getCarType:self.dataDic];
            for (NSArray *cars in carArray) {
                
                PorscheSchemeCarModel *carmodel = [PorscheSchemeCarModel new];
                for (NSInteger i = 0; i < cars.count ; i++) {
                    NSString *string = cars[i];
                    if (i == 0) carmodel.wocarcatena = string;
                    if (i == 1) carmodel.wocarmodel = string;
                    if (i == 2) carmodel.woyearstyle = string;
                    if (i == 3) carmodel.wooutputvolume = string;
                }
                [self.cars addObject:carmodel];
            }
            self.saveBlcok([self.cars copy]);
        } else {
            
            NSMutableArray *carArray = [[NSMutableArray alloc] init];
            PorscheSchemeCarModel *carmodel = [PorscheSchemeCarModel new];
            for (NSInteger i = 0; i < self.oneArray.count ; i++) {
                NSString *string = self.oneArray[i];
                if (i == 0) carmodel.wocarcatena = string;
                if (i == 1) carmodel.wocarmodel = string;
                if (i == 2) carmodel.woyearstyle = string;
                if (i == 3) carmodel.wooutputvolume = string;
            }
            if (![carmodel.wocarcatena isEqualToString:@""]) {
                [carArray addObject:carmodel];
            }
            self.saveBlcok([carArray copy]);
        }
        
    }
    [self removeFromSuperview];
}
- (IBAction)cancleAction:(id)sender {
    
     [self removeFromSuperview];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];

}

- (NSMutableArray *)getCarType:(NSMutableDictionary *)dic {
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < dic.allKeys.count; i++) {
        
        NSString *str_1 = dic.allKeys[i];
        NSMutableDictionary *dic_1 = [dic valueForKey:str_1];
        
        if (!dic_1.allKeys.count) {
            NSArray *arr = @[str_1];
            [dataArray addObject:arr];
            continue;
        }
        
        for (NSInteger k = 0; k < dic_1.allKeys.count; k ++) {
            
            NSString *str_2 = dic_1.allKeys[k];
            NSMutableDictionary *dic_2 = [dic_1 valueForKey:str_2];
            
            if (!dic_2.allKeys.count) {
                NSArray *arr = @[str_1,str_2];
                [dataArray addObject:arr];
                continue;
            }
            for (NSInteger j = 0; j < dic_2.allKeys.count; j ++) {
                
                NSString *str_3 = dic_2.allKeys[j];
                NSMutableDictionary *dic_3 = [dic_2 valueForKey:str_3];
                
                if (!dic_3.allKeys.count) {
                    NSArray *arr = @[str_1,str_2,str_3];
                    [dataArray addObject:arr];
                    continue;
                }
                
                for (NSInteger n = 0; n < dic_3.allKeys.count; n ++) {
                    
                    NSString *str_4 = dic_3.allKeys[n];
                    NSArray *arr = @[str_1,str_2,str_3,str_4];
                    [dataArray addObject:arr];
                }
            }
        }
    }
    
    return dataArray;
}


@end
