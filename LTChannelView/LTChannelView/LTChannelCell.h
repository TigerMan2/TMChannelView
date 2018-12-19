//
//  LTChannelCell.h
//  LTChannelView
//
//  Created by wangpeng on 2018/12/19.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTChannelModel.h"

@interface LTChannelCell : UICollectionViewCell

/** 频道的样式 */
@property (nonatomic, assign) LTChannelType channelType;

@property (nonatomic, strong) LTChannelModel *model;

/** 标题Label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 删除图标 */
@property (nonatomic, strong) UIImageView *delBtn;

@end
