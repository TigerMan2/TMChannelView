//
//  TMChannelView.m
//  TMChannelView
//
//  Created by wangpeng on 2018/12/19.
//  Copyright © 2018 mrstock. All rights reserved.
//

#import "TMChannelView.h"
#import "TMChannelCell.h"

@interface TMChannelView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UIScrollViewDelegate
>
{
    NSMutableArray *_myTags;
    NSMutableArray *_recommendTags;
    
    UIButton *_editBtn;//编辑按钮
    BOOL _tagDeletable;
    BOOL _isEdit;//tags是否在编辑状态
    
    //被拖拽的item
    TMChannelCell *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    
}
@property (nonatomic, strong) UICollectionView *mainView;
/** 我喜欢的频道 */
@property (nonatomic, strong) NSMutableArray *myChannels;
/** 推荐的频道 */
@property (nonatomic, strong) NSMutableArray *recommendChannels;
@end

@implementation TMChannelView

- (instancetype)initWithFrame:(CGRect)frame myTags:(NSArray *)myTags recommendTags:(NSArray *)recommendTags {
    self = [super initWithFrame:frame];
    if (self) {
        _myChannels = myTags.mutableCopy;
        _recommendChannels = recommendTags.mutableCopy;
        [self makeTags];
        [self setupUI];
    }
    return self;
}
/** 处理数据 */
- (void)makeTags {
    _myTags = @[].mutableCopy;
    _recommendTags = @[].mutableCopy;
    NSInteger index = 0;
    for (NSString *title in _myChannels) {
        TMChannelModel *model = [[TMChannelModel alloc] init];
        model.title = title;
        model.selected = NO;
        if (index == 0 || index == 1) {
            model.resident = YES;
        }
        model.channelType = TMChannelTypeMy;
        [_myTags addObject:model];
        index ++;
    }
    
    for (NSString *title in _recommendChannels) {
        TMChannelModel *model = [[TMChannelModel alloc] init];
        model.title = title;
        model.selected = NO;
        model.channelType = TMChannelTypeRecommend;
        [_recommendTags addObject:model];
    }
}

- (void)setupUI {
    [self.dragContentView addSubview:self.mainView];
    
    _dragingItem = [[TMChannelCell alloc] initWithFrame:CGRectMake(0, 0, self.width/4-10, 53)];
    _dragingItem.hidden = true;
    [self.mainView addSubview:_dragingItem];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainView.frame = self.dragContentView.bounds;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _myTags.count;
    }
    return _recommendTags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellIdentifier";
    TMChannelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_myTags.count>indexPath.item) {
            cell.model = _myTags[indexPath.item];
            if (_isEdit) {
                if (cell.model.resident) {
                    cell.delBtn.hidden = YES;
                }else{
                    cell.delBtn.hidden = NO;
                }
            }else{
                cell.delBtn.hidden = YES;
            }
        }
    }else if (indexPath.section == 1){
        if (_recommendTags.count>indexPath.item) {
            cell.model = _recommendTags[indexPath.item];
            cell.delBtn.hidden = YES;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.width/4-10, 53);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 4, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 50);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = @"head1";
            header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            UILabel *lab1 = [[UILabel alloc]init];
            [header addSubview:lab1];
            lab1.text = @"我的频道";
            lab1.frame = CGRectMake(20, 0, 100, 60);
            lab1.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
            
            UILabel *lab2 = [[UILabel alloc]init];
            [header addSubview:lab2];
            lab2.text = @"点击进入频道";
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.frame = CGRectMake(100, 2, 200, 60);
            lab2.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
            
            _editBtn = [[UIButton alloc]init];
            _editBtn.frame = CGRectMake(collectionView.frame.size.width-60, 13, 44, 28);
            [header addSubview:_editBtn];
            [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            _editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [_editBtn setTitleColor:[UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0] forState:UIControlStateNormal];
            _editBtn.layer.borderColor = [UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0].CGColor;
            _editBtn.layer.masksToBounds = YES;
            _editBtn.layer.cornerRadius = 14;
            _editBtn.layer.borderWidth = 0.8;
            [_editBtn addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = @"head2";
            header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            UILabel *lab1 = [[UILabel alloc]init];
            [header addSubview:lab1];
            lab1.text = @"频道推荐";
            lab1.frame = CGRectMake(20, 0, 100, 60);
            lab1.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
            
            UILabel *lab2 = [[UILabel alloc]init];
            [header addSubview:lab2];
            lab2.text = @"点击添加频道";
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.frame = CGRectMake(100, 2, 200, 60);
            lab2.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        }
    }
    return header;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    TMChannelCell *cell = (TMChannelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell.model.resident) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TMChannelCell *cell = (TMChannelCell *)[_mainView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"indexPath.row----%ld",indexPath.row);
    NSLog(@"indexPath.item----%ld",indexPath.item);
    NSLog(@"indexPath.section----%ld",indexPath.section);
    
    if (indexPath.section == 0) {
        if (_isEdit) {  //编辑状态下
            //常驻的不可删除
            TMChannelModel *model = _myTags[indexPath.item];
            if (model.resident) {return;}
            //设置cell的model
            model.channelType = TMChannelTypeRecommend;
            cell.model = model;
            cell.delBtn.hidden = YES;
            
            id obj = [_myTags objectAtIndex:indexPath.row];
            [_myTags removeObject:obj];
            [_recommendTags insertObject:obj atIndex:0];
            [_mainView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        } else {
            //非编辑状态下
            [self popOut];
        }
        
    }else{
        
        TMChannelModel *model = _recommendTags[indexPath.item];
        //设置cell的model
        model.channelType = TMChannelTypeMy;
        cell.model = model;
        cell.delBtn.hidden = !_isEdit;
        
        id obj = [_recommendTags objectAtIndex:indexPath.row];
        [_recommendTags removeObject:obj];
        [_myTags addObject:obj];
        [_mainView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_myTags.count - 1 inSection:0]];
    }
}

/** 进入编辑状态 */
- (void)editTags:(UIButton *)sender{
    
    if (!_isEdit) {
        for (TMChannelCell *cell in _mainView.visibleCells) {
            if (cell.model.channelType == TMChannelTypeMy) {
                if (cell.model.resident) {
                    cell.delBtn.hidden = YES;
                }else{
                    cell.delBtn.hidden = NO;
                }
            } else {
                cell.delBtn.hidden = YES;
            }
        }
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        for (TMChannelCell *cell in _mainView.visibleCells) {
            cell.delBtn.hidden = YES;
        }
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    _isEdit = !_isEdit;
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:_mainView];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self dragBegin:point];
        if (!_isEdit) {
            [self editTags:_editBtn];
        }
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [self dragChanged:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [self dragEnd];
        //其他情况
    } else {
        [_mainView cancelInteractiveMovement];
    }
}
/** 拖拽开始 */
- (void)dragBegin:(CGPoint)point {
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_mainView bringSubviewToFront:_dragingItem];
    TMChannelCell *item = (TMChannelCell *)[_mainView cellForItemAtIndexPath:_dragingIndexPath];
    item.hidden = YES;
    //更新被拖拽的item
    _dragingItem.frame = item.frame;
    _dragingItem.model = item.model;
    _dragingItem.hidden = NO;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
}
/** 正在被拖拽... */
- (void)dragChanged:(CGPoint)point {
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置，如果没有找到_targetIndexPath，则不交换
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
        //更新item位置
        [_mainView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}
/** 拖拽结束 */
- (void)dragEnd {
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_mainView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        _dragingItem.frame = endFrame;
    } completion:^(BOOL finished) {
        _dragingItem.hidden = YES;
        TMChannelCell *item = (TMChannelCell *)[_mainView cellForItemAtIndexPath:_dragingIndexPath];
        item.hidden = NO;
    }];
    
}
/** 更新数据源 */
- (void)rearrangeInUseTitles {
    id obj = [_myTags objectAtIndex:_dragingIndexPath.row];
    [_myTags removeObject:obj];
    [_myTags insertObject:obj atIndex:_targetIndexPath.row];
}

/** 获取被拖动IndexPath的方法 */
-(NSIndexPath *)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    for (NSIndexPath *indexPath in _mainView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_mainView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    TMChannelModel *model = _myTags[dragIndexPath.item];
    if (model.resident) {
        return nil;
    }
    return dragIndexPath;
}

/** 获取目标IndexPath的方法 */
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _mainView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //第二组不需要排序
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_mainView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                targetIndexPath = indexPath;
            }
        }
    }
    TMChannelModel *model = _myTags[targetIndexPath.item];
    if (model.resident) {
        return nil;
    }
    return targetIndexPath;
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    if(offset.y < 0 ){
        offset.y = 0 ;
        scrollView.contentOffset = offset ;
    }
}

#pragma mark - @property getter
- (UICollectionView *)mainView {
    if (!_mainView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[TMChannelCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        //添加长按的手势
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [collectionView addGestureRecognizer:longPress];
        _mainView = collectionView;
    }
    return _mainView;
}

@end
