//
//  TMChannelModel.h
//  TMChannelView
//
//  Created by wangpeng on 2018/12/19.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TMChannelType) {
    TMChannelTypeMy,            //我的频道样式，不带“+”
    TMChannelTypeRecommend,     //推荐频道样式 带“+”
};

@interface TMChannelModel : NSObject
/** 是否是常驻 */
@property (nonatomic, assign) BOOL resident;


@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) TMChannelType channelType;

@end
