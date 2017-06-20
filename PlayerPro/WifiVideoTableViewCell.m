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
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *sizeLabel;
    UILabel *timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(7);
            make.top.equalTo(self.contentView).offset(7);
            make.bottom.equalTo(self.contentView).offset(-7);
            make.width.mas_equalTo(90);
        }];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor colorWithHexString:@"#515151"];
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView);
            make.left.equalTo(imageView.mas_right).offset(13);
            make.right.equalTo(self.contentView).offset(-7);
            make.height.mas_equalTo(25);
        }];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"#1296db"];
        timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeLabel];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView).offset(-4);
            make.left.equalTo(titleLabel);
            make.height.mas_equalTo(20);
        }];
        
        
        sizeLabel = [[UILabel alloc]init];
        sizeLabel.textColor = [UIColor colorWithHexString:@"#1296db"];
        sizeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:sizeLabel];
        
        [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView).offset(-4);
            make.left.equalTo(titleLabel).offset(120);
            make.height.mas_equalTo(20);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#515151"];
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

-(void)loadData:(AppLocaVideoModel *)model{
    titleLabel.text = model.title;
    timeLabel.text = model.time;
    sizeLabel.text = model.size;
    imageView.image = model.image;
}

-(void)loadVideoData:(VideoModel *)model{
    titleLabel.text = model.title;
    timeLabel.text = model.time;
    NSString *image;
    if ([model.img rangeOfString:@"https"].length > 0) {
        image = [[NSString alloc]initWithFormat:@"%@",model.img];
    }else{
        image = [[NSString alloc]initWithFormat:@"https:%@",model.img];
    }
    
    [imageView setImageWithURLString:image placeholder:ZFPlayerImage(@"ZFPlayer_loading_bgView")];
}
@end
