//
//  LTChannelCell.m
//  LTChannelView
//
//  Created by wangpeng on 2018/12/19.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import "LTChannelCell.h"

@interface LTChannelCell ()

@end

@implementation LTChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.delBtn];
    }
    return self;
}

- (void)setModel:(LTChannelModel *)model {
    _model = model;
    
    if (model.channelType == LTChannelTypeMy) {
        //如果标题包含“+” 则删除
        if ([model.title containsString:@"+"]) {
            model.title = [model.title substringFromIndex:1];
        }
        //选择出来的tag高亮显示
        if (model.selected) {
            self.titleLabel.textColor = [UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0];
        }else{
            self.titleLabel.textColor = [UIColor blackColor];
        }
    } else if (model.channelType == LTChannelTypeRecommend) {
        //如果标题不包含“+” 则添加
        if (![model.title containsString:@"+"]) {
            model.title = [@"+" stringByAppendingString:model.title];
        }
        self.delBtn.hidden = YES;
    }
    
    self.titleLabel.text = model.title;
}

#pragma mark - @property getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.lt_width - 10, self.lt_height - 10)];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = M_PI;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor lightGrayColor];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)delBtn {
    if (!_delBtn) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(self.lt_width - 18, 0, 18, 18)];
        view.image = [UIImage imageNamed:@"del"];
        _delBtn = view;
    }
    return _delBtn;
}

@end
