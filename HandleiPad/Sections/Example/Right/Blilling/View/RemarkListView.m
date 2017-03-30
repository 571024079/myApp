//
//  RemarkListView.m
//  HandleiPad
//
//  Created by Handlecar on 10/21/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "RemarkListView.h"
#import "RemarkListCell.h"
#import "RemarkListModel.h"
#define VIEW_MAX_HEIGHT   279
#define TABLEVIEW_MAX_HEIGHT 273

#define TEXTVIEW_HEIGHT  17
@interface RemarkListView ()<UITableViewDataSource, UITableViewDelegate,RemarkListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RemarkListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"RemarkListCell" bundle:nil] forCellReuseIdentifier:@"remarklist"];
//    [self configTestModel1];
    
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
}


- (void)setViewFormStyle:(ViewForm)viewFormStyle {
    _viewFormStyle = viewFormStyle;
    
    [self reConfigData];
}

- (void)reConfigData
{
    if (_viewFormStyle != ViewForm_serviceRecordsRightBtn) {
        RemarkListModel *copyModel = [[RemarkListModel alloc] init];
        copyModel.womrecordcontent = @"";
        copyModel.womrecordperson = [HDStoreInfoManager shareManager].userid;
        copyModel.womrecorddate = [[NSDate date] convertToString:@"yyyyMMddHHmmss"];
        copyModel.nickname = [[HDStoreInfoManager shareManager] nickname];
        PorscheConstantModel *position = [[CoreDataManager shareManager] queryPostionInfoWithPositionId:[[HDStoreInfoManager shareManager] positionid]];
        copyModel.usertype = position.cvvaluedesc;
        [_dataSource insertObject:copyModel atIndex:0];
    }
    [_tableView reloadData];
}

//- (void)setType:(NSInteger)type
//{
//    _type = type;
//    
//    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:self.dataSource];
//    if (type > 0)
//    {
//        [dataSource insertObject:[self makeAemptyDataWithType:type] atIndex:0];
//    }
//    self.dataSource = dataSource;
//    [_tableView reloadData];
//}

//- (RemarkListModel *)makeAemptyDataWithType:(NSInteger)type
//{
//    for (RemarkListModel *model in self.dataSource)
//    {
//        if ([model.stafftypeid integerValue] == type)
//        {
//            RemarkListModel *copyModel = [[RemarkListModel alloc] init];
//            copyModel.stafftypeid = model.stafftypeid;
//            copyModel.staffname =  model.staffname;
//            copyModel.staffremark =  @"";
//            copyModel.stafftype =  model.stafftype;
//            return copyModel;
//        }
//    }
//    return [[RemarkListModel alloc] init];
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemarkListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remarklist"];
    RemarkListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.someOneSayLabel.text = [NSString stringWithFormat:@"%@%@说:",model.usertype,model.nickname];
    cell.remarkTextView.text = model.womrecordcontent;
    cell.remarkTimeLabel.text = [model.womrecorddate convertFromFormat:@"yyyyMMddHHmmss" toAnotherFormat:@"yyyy-MM-dd HH:mm"];
    
    if (([model.womrecordperson integerValue] == [[[HDStoreInfoManager shareManager] userid] integerValue])
        && (_viewFormStyle != ViewForm_serviceRecordsRightBtn)
        &&[HDPermissionManager isHasThisPermission:HDOrder_Remark_Edit isNeedShowMessage:NO])
    {
        [cell remarkShouldEidt:YES];
    }
    else
    {
        [cell remarkShouldEidt:NO];
    }
    
    cell.delegate = self;
    return cell;
}

//- (float) heightForString:(UITextView *)textView andWidth:(float)width{
//    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
//    return sizeToFit.height;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemarkListModel *model = [self.dataSource objectAtIndex:indexPath.row];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell.contentView layoutIfNeeded];
//    [cell.contentView layoutSubviews];
    if (!model.womrecordcontent.length)
    {
        return 63;
    }
    float height = [self heightForString:model.womrecordcontent andWidth:177];
    
    if (height > 17)
    {
        return 63 + height - 17;
    }
    
    return 63;
}


- (void)remarkCell:(RemarkListCell *)cell textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)remarkCell:(RemarkListCell *)cell textViewDidEndEditing:(UITextView *)textView
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    RemarkListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    model.womrecordcontent = textView.text;
    
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    WeakObject(self);
    // 新增备注
    if (indexPath.row == 0)
    {
       /*
        type    //类型  1：文字   2：语音
        content;      //文字内容
        soundurl;     //语音URL
        */
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:@1 forKey:@"type"];
        [param hs_setSafeValue:textView.text forKey:@"content"];
        [self addMemoTextWith:param completion:^(PResponseModel *responser) {
            [selfWeak memoTextListCompletion];
        }];
    }
    // 编辑备注
    else
    {
        /*
         编辑备忘录
         /orderprocess/ordereditmeno
         参数：
         id    备忘录id
         type    类型  1：文字   2：语音
         content;      //文字内容
         soundurl;     //语音URL
         还有外层的操作用户
         */
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:model.womid forKey:@"id"];
        [param hs_setSafeValue:@1 forKey:@"type"];
        [param hs_setSafeValue:textView.text forKey:@"content"];
        [self editMemoTextWith:param completion:^(PResponseModel *responser) {
            [selfWeak memoTextListCompletion];
        }];
    }
}

/**
 添加备忘录
 */
- (void)addMemoTextWith:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion
{
    [PorscheRequestManager addMemoTextWith:param completion:completion];
}

/**
 编辑备忘录
 */
- (void)editMemoTextWith:(NSDictionary *)param completion:(void (^)(PResponseModel* responser))completion
{
    [PorscheRequestManager editMemoTextWith:param completion:completion];
}
/**
 备忘录列表
 */
- (void)memoTextListCompletion
{
    WeakObject(self);
    [PorscheRequestManager memoTextListCompletion:^(NSArray<RemarkListModel *> * _Nonnull memoList, PResponseModel * _Nonnull responser) {
        selfWeak.dataSource = [NSMutableArray arrayWithArray:memoList];
        [selfWeak reConfigData];
    }];
}
/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
//    _text.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height;
}
@end
