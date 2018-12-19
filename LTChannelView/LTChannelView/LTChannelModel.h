//
//  LTChannelModel.h
//  LTChannelView
//
//  Created by wangpeng on 2018/12/19.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTChannelType) {
    LTChannelTypeMy,            //我的频道样式，不带“+”
    LTChannelTypeRecommend,     //推荐频道样式 带“+”
};

@interface LTChannelModel : NSObject
/** 是否是常驻 */
@property (nonatomic, assign) BOOL resident;


@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) LTChannelType channelType;

@end
