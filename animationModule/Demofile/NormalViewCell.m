//
//  NormalViewCell.m
//  animationModule
//
//  Created by WuChuMing on 2018/11/23.
//  Copyright © 2018年 WuChuMing. All rights reserved.
//

#import "NormalViewCell.h"

@implementation NormalViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIImageView *ImgV = [[UIImageView alloc] initWithFrame: CGRectMake(10, 10, 105, 105)];
    ImgV.backgroundColor = [UIColor grayColor];
    ImgV.image = [UIImage imageNamed:@""];
    ImgV.layer.cornerRadius = 20.f;
    ImgV.layer.masksToBounds = YES;
    [self addSubview:ImgV];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ImgV.frame) + 10, CGRectGetMidY(ImgV.frame) - 50, 200, 30)];
    title.text = @"我是一个游戏";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor blackColor];
    [self addSubview:title];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ImgV.frame)+10,  CGRectGetMaxY(title.frame)+5, 150, CGRectGetHeight(ImgV.frame)-CGRectGetMaxY(title.frame)-5)];
    content.text = @"这个游戏很厉害，厉害到爆炸,牛不牛，你玩一下就知道，走过路过别错过";
    content.numberOfLines = 0;
    content.font = [UIFont systemFontOfSize:14];
    [self addSubview:content];
    
    UIButton *accquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accquireButton.frame = CGRectMake(0, 0, 50, 25);
    accquireButton.layer.cornerRadius = 12.5f;
    accquireButton.layer.masksToBounds = YES;
    [accquireButton setTitle:@"获取" forState:0];
    [accquireButton setTitleColor:[UIColor blueColor] forState:0];
    accquireButton.layer.borderWidth = 1.f;
    accquireButton.layer.borderColor = [UIColor blueColor].CGColor;
    accquireButton.center = CGPointMake(310, 125.0/2);
    [self addSubview:accquireButton];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
