//
//  TMChannelCell.h
//  TMChannelView
//
//  Created by wangpeng on 2018/12/19.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMChannelModel.h"
#import "UIView+TMFrame.h"

@interface TMChannelCell : UICollectionViewCell

/** 频道的样式 */
@property (nonatomic, assign) TMChannelType channelType;

@property (nonatomic, strong) TMChannelModel *model;

/** 标题Label */
@property (nonatomic, strong) UILabel *titleLabel;
/** 删除图标 */
@property (nonatomic, strong) UIImageView *delBtn;

@end
