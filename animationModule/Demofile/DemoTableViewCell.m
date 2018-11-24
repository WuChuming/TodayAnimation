//
//  DemoTableViewCell.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/21.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "DemoTableViewCell.h"
#import "NormalViewCell.h"

@implementation DemoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor colorWithRed:random()%256*1.0/256 green:random()%256*1.0/256 blue:random()%256*1.0/256 alpha:1];
        [self.bgView addSubview:self.myTableView];
        [self.myTableView registerClass:[NormalViewCell class] forCellReuseIdentifier:@"normalCell"];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.TdataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
//    cell.imageView.image = [UIImage imageNamed:@"test"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.textLabel.text = self.TdataArr[indexPath.row];
    return cell;
}

#pragma mark ------TableView----
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.bgView.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.userInteractionEnabled = NO;
        _myTableView.scrollEnabled = NO;
    }
    return _myTableView;
}

- (NSMutableArray *)TdataArr{
    if (!_TdataArr) {
        _TdataArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",nil];
    }
    return _TdataArr;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 480)];
        _bgView.layer.cornerRadius = 10.f;
//        _bgView.layer.masksToBounds = YES;
        _bgView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bgView.layer.shadowOpacity = 0.4;
        _bgView.layer.cornerRadius = 5;
//        _bgView.layer.shadowOffset = CGSizeMake(10, 10);
    }
    return _bgView;
}


@end
