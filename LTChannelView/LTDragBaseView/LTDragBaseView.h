//
//  LTDragBaseView.h
//  LTChannelView
//
//  Created by wangpeng on 2018/12/18.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTDragBaseView : UIView

/** 用户设置整个视图的背景 */
@property (nonatomic, strong, readonly) UIView *dragViewBg;
/** 需要显示的视图都加到dragContentView里面 */
@property (nonatomic, strong, readonly) UIView *dragContentView;

/** dragContentView距离屏幕上方的距离 默认是0*/
@property (nonatomic, assign) CGFloat topSpace;
/** dragContentView的圆角 默认是0*/
@property (nonatomic, assign) CGFloat contentViewCornerRadius;
/** 设定dragContentView的哪些边需要圆角 默认是所有边*/
@property (nonatomic, assign) UIRectCorner cornerEdge;

/** 视图的展示与隐藏 */
- (void)popIn;
- (void)popOut;

#pragma mark -- 开始、拖拽中、结束拖拽

- (void)dragBeginWithPoint:(CGPoint)pt;
- (void)dragingWithPoint:(CGPoint)pt offset:(BOOL)offset;
- (void)dragEndWithPoint:(CGPoint)pt shouldHideView:(BOOL)hideView;

#pragma mark -- 视图显示/消失

- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;

@end
