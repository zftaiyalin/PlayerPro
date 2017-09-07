//
//  WifiVideoTableViewCell.m
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/17.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "WifiVideoTableViewCell.h"
#import "ZFPlayer.h"

@implementation WifiVideoTableViewCell{
    UIImageView *imageView;/*打乱代码结构*/
    UILabel *titleLabel;/*打乱代码结构*/
    UILabel *sizeLabel;/*打乱代码结构*/
    UILabel *timeLabel;/*打乱代码结构*/
}

- (void)awakeFromNib {
    [super awakeFromNib];/*打乱代码结构*//*打乱代码结构*/
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];/*打乱代码结构*//*打乱代码结构*/

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];/*打乱代码结构*//*打乱代码结构*/
    if (self) {
        
        imageView = [[UIImageView alloc]init];/*打乱代码结构*//*打乱代码结构*/
        imageView.contentMode = UIViewContentModeScaleAspectFill;/*打乱代码结构*/
        imageView.clipsToBounds = YES;/*打乱代码结构*/
        [self.contentView addSubview:imageView];/*打乱代码结构*//*打乱代码结构*/
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(7);/*打乱代码结构*/
            make.top.equalTo(self.contentView).offset(7);/*打乱代码结构*/
            make.bottom.equalTo(self.contentView).offset(-7);/*打乱代码结构*/
            make.width.mas_equalTo(90);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
        
        titleLabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
        titleLabel.font = [UIFont systemFontOfSize:17];/*打乱代码结构*//*打乱代码结构*/
        titleLabel.textColor = [UIColor colorWithHexString:@"#515151"];/*打乱代码结构*//*打乱代码结构*/
        [self.contentView addSubview:titleLabel];/*打乱代码结构*//*打乱代码结构*/
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView);/*打乱代码结构*/
            make.left.equalTo(imageView.mas_right).offset(13);/*打乱代码结构*/
            make.right.equalTo(self.contentView).offset(-7);/*打乱代码结构*/
            make.height.mas_equalTo(25);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
        
        timeLabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
        timeLabel.textColor = [UIColor colorWithHexString:@"#1296db"];/*打乱代码结构*//*打乱代码结构*/
        timeLabel.font = [UIFont systemFontOfSize:13];/*打乱代码结构*//*打乱代码结构*/
        [self.contentView addSubview:timeLabel];/*打乱代码结构*//*打乱代码结构*/
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView).offset(-4);/*打乱代码结构*/
            make.left.equalTo(titleLabel);/*打乱代码结构*/
            make.height.mas_equalTo(20);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
        
        
        sizeLabel = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
        sizeLabel.textColor = [UIColor colorWithHexString:@"#1296db"];/*打乱代码结构*//*打乱代码结构*/
        sizeLabel.font = [UIFont systemFontOfSize:13];/*打乱代码结构*//*打乱代码结构*/
        [self.contentView addSubview:sizeLabel];/*打乱代码结构*//*打乱代码结构*/
        
        [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView).offset(-4);/*打乱代码结构*/
            make.left.equalTo(titleLabel).offset(120);/*打乱代码结构*/
            make.height.mas_equalTo(20);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
        
        UIView *line = [[UIView alloc]init];/*打乱代码结构*//*打乱代码结构*/
        line.backgroundColor = [UIColor colorWithHexString:@"#515151"];/*打乱代码结构*//*打乱代码结构*/
        [self.contentView addSubview:line];/*打乱代码结构*//*打乱代码结构*/
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(self.contentView);/*打乱代码结构*/
            make.height.mas_equalTo(0.5);/*打乱代码结构*/
        }];/*打乱代码结构*//*打乱代码结构*/
    }
    return self;/*打乱代码结构*/
}

-(void)loadData:(AppLocaVideoModel *)model{
    titleLabel.text = model.title;/*打乱代码结构*/
    timeLabel.text = model.time;/*打乱代码结构*/
    sizeLabel.text = model.size;/*打乱代码结构*/
    imageView.image = model.image;/*打乱代码结构*/
}

-(void)loadVideoData:(VideoModel *)model{
    titleLabel.text = model.title;/*打乱代码结构*/
    timeLabel.text = model.time;/*打乱代码结构*/
    NSString *image;/*打乱代码结构*/
    if ([model.img rangeOfString:@"https"].length > 0) {
        image = [[NSString alloc]initWithFormat:@"%@",model.img];/*打乱代码结构*//*打乱代码结构*/
    }else{
        image = [[NSString alloc]initWithFormat:@"https:%@",model.img];/*打乱代码结构*//*打乱代码结构*/
    }
    
    [imageView setImageWithURLString:image placeholder:ZFPlayerImage(@"ZFPlayer_loading_bgView")];/*打乱代码结构*//*打乱代码结构*/
}
@end
