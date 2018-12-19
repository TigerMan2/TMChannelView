//
//  LTDragBaseView.m
//  LTChannelView
//
//  Created by wangpeng on 2018/12/18.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import "LTDragBaseView.h"

@interface LTDragBaseView ()<UIGestureRecognizerDelegate,CAAnimationDelegate>

/** 用户设置整个视图的背景 */
@property (nonatomic, strong, readwrite) UIView *dragViewBg;
/** 需要显示的视图都加到dragContentView里面 */
@property (nonatomic, strong, readwrite) UIView *dragContentView;
/** 视图拖拽的手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation LTDragBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dragContentView.frame = CGRectMake(0, _topSpace, self.lt_width, self.lt_height - _topSpace);
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)initialize {
    self.topSpace = 0;
    self.contentViewCornerRadius = 0;
    self.cornerEdge = UIRectCornerAllCorners;
    [self addGestureRecognizer:self.panGesture];
    [self addSubview:self.dragViewBg];
    [self addSubview:self.dragContentView];
    
    self.dragContentView.frame = CGRectMake(0, _topSpace, self.lt_width, self.lt_height - _topSpace);
    
    [self.dragViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
}

#pragma mark - 拖拽手势
- (void)panRecognizer:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState state = gesture.state;
    CGPoint point = [gesture translationInView:self];
    if (state == UIGestureRecognizerStateChanged) { //移动
        CGFloat y = self.dragContentView.lt_y;
        [self dragingWithPoint:[gesture locationInView:self] offset:(y + point.y) < self.topSpace];
        if (y + point.y < self.topSpace) {
            self.dragContentView.lt_y = self.topSpace;
            return;
        }
        //背景的alpha
        self.dragContentView.lt_centerY += point.y;
        CGFloat alpha = (1.0 - (y - self.topSpace) / self.dragContentView.lt_height);
        self.dragViewBg.alpha = MAX(alpha, 0);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
    } else if (state == UIGestureRecognizerStateEnded ||
               state == UIGestureRecognizerStateFailed ||
               state == UIGestureRecognizerStateCancelled) {
        BOOL showHideView = NO;
        CGFloat y = self.dragContentView.lt_y;
        CGFloat maxOffset = self.dragContentView.lt_height / 6;
        if (y - self.topSpace >= maxOffset) {
            showHideView = YES;
            //视图dismiss
            [self popOut];
        } else {
            //重置视图
            [self resetView];
        }
        [self dragEndWithPoint:[gesture locationInView:self] shouldHideView:showHideView];
    } else if (state == UIGestureRecognizerStateBegan) {
        [self dragBeginWithPoint:[gesture locationInView:self]];
    }
}

#pragma mark - 恢复视图的正确位置
- (void)resetView {
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.dragViewBg.alpha = 1.0;
                         self.dragContentView.lt_y = self.topSpace;
                         self.dragContentView.layer.transform = CATransform3DIdentity;
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - 视图的显示与隐藏动画
- (void)popIn {
    [self viewWillAppear];
    self.dragViewBg.alpha = 0.0;
    self.dragContentView.lt_y = UIDeviceScreenHeight;
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.85
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dragViewBg.alpha = 1.0;
                         self.dragContentView.lt_y = self.topSpace;
                     } completion:^(BOOL finished) {
                         [self viewDidAppear];
                     }];
}

- (void)popOut {
    [self viewWillDisappear];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.dragContentView.lt_y = UIDeviceScreenHeight;
                         self.dragViewBg.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self viewDidDisappear];
                         [self removeFromSuperview];
                         [self removeGestureRecognizer:self.panGesture];
                     }];
}

#pragma mark -- 开始、结束拖拽

- (void)dragBeginWithPoint:(CGPoint)pt{
    
}

- (void)dragingWithPoint:(CGPoint)pt offset:(BOOL)offset{
    
}

- (void)dragEndWithPoint:(CGPoint)pt shouldHideView:(BOOL)hideView{
    
}

#pragma mark -- 视图显示/消失

- (void)viewWillAppear{
    
}

- (void)viewDidAppear{
    
}

- (void)viewWillDisappear{
    
}

- (void)viewDidDisappear{
}

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIView *view = otherGestureRecognizer.view ;
    //与上下滚动的视图有冲突
    if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *view = (UICollectionView *)otherGestureRecognizer.view;
        if(view.contentOffset.y > 0.0){
            return NO ;
        }
        return YES;
    }
    return NO;
}

#pragma mark - 设置圆角
- (void)adjustCornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight) byRoundingCorners:self.cornerEdge cornerRadii:CGSizeMake(self.contentViewCornerRadius, self.contentViewCornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight);
    maskLayer.path = maskPath.CGPath;
    self.dragContentView.layer.mask = maskLayer;
}

- (void)setContentViewCornerRadius:(CGFloat)contentViewCornerRadius {
    _contentViewCornerRadius = contentViewCornerRadius;
    [self adjustCornerRadius];
}

- (void)setCornerEdge:(UIRectCorner)cornerEdge {
    _cornerEdge = cornerEdge;
    [self adjustCornerRadius];
}

#pragma mark - @property getter
- (UIView *)dragViewBg {
    if (!_dragViewBg) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        _dragViewBg = view;
    }
    return _dragViewBg;
}
- (UIView *)dragContentView {
    if (!_dragContentView) {
        UIView *view = [[UIView alloc] init];
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        _dragContentView = view;
    }
    return _dragContentView;
}
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
        panGesture.delegate = self;
        _panGesture = panGesture;
    }
    return _panGesture;
}

@end
