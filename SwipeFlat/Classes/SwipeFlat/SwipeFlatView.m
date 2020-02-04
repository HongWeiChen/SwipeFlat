//
//  SwipeFlatView.m
//  SwipeFlat
//
//  Created by Mystery on 2020/2/4.
//  Copyright © 2020 ChenHongWei. All rights reserved.
//

#import "SwipeFlatView.h"

@interface SwipeFlatView ()<UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isChildViewsLoaded;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *childViews;
@property (strong, nonatomic) SwipeFlatConfiguration *configuration;

@property (assign, nonatomic) NSUInteger selectedIndex;

@end

@implementation SwipeFlatView

- (instancetype)initWithConfiguration:(SwipeFlatConfiguration *)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
        self.isChildViewsLoaded = false;
        self.childViews = @[].mutableCopy;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.configuration = [[SwipeFlatConfiguration alloc] init];
        self.isChildViewsLoaded = false;
        self.childViews = @[].mutableCopy;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    if (self.delegate == nil) {
        return;
    }
    
    if (self.isChildViewsLoaded == false) {
        [self loadChildViews];
    }
    [self layoutChildViewFrames];
}

- (void)loadChildViews {
    self.isChildViewsLoaded = true;
    NSUInteger number = [self.delegate numberOfCountForSwipeFlatView:self];
    if (number == 0) {
        return;
    }
    
    for (int i = 0; i < number; i++) {
        UIView *childView = [UIView new];
        [self.scrollView addSubview:childView];
        [self.childViews addObject:childView];
        if (self.configuration.isLazyLoadChildViews == false || i == self.selectedIndex) {
            UIView *contentView = [self.delegate swipeFlatView:self viewForItemAtIndex:i];
            NSAssert(contentView, @"View cannot be empty");
            [childView addSubview:contentView];
        }
    }
}

- (void)layoutChildViewFrames {
    for (int i = 0; i < self.childViews.count; i++) {
        float width = self.frame.size.width;
        float height = self.frame.size.height;
                        
        UIView *childView = [self.childViews objectAtIndex:i];
        childView.frame = CGRectMake(i * width, 0, width, height);
        
        UIView *contentView = childView.subviews.firstObject;
        if (contentView != nil) {
            [self  layoutContentView:contentView atIndex:i];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.childViews.count * self.frame.size.width, self.frame.size.height);
    CGPoint point = CGPointMake(self.selectedIndex * self.scrollView.frame.size.width, 0);
    [self.scrollView setContentOffset:point animated:false];
}

- (void)layoutContentView:(UIView *)contentView atIndex:(NSInteger)index {
    float width = self.frame.size.width;
    float height = self.frame.size.height;

    UIEdgeInsets edge = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(swipeFlatView:edgesForItemAtIndex:)]) {
        edge = [self.delegate swipeFlatView:self edgesForItemAtIndex:index];
    }

    float contentWidth = width - edge.left - edge.right;
    float contentHeight = height - edge.top - edge.bottom;
    if (contentWidth < 0) {
        contentWidth = 0;
    }
    if (contentHeight < 0) {
        contentHeight = 0;
    }
    contentView.frame = CGRectMake(edge.left, edge.top, contentWidth, contentHeight);

}

- (void)reloadData {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self loadChildViews];
    [self layoutChildViewFrames];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSUInteger index = targetContentOffset->x / scrollView.frame.size.width;
    _selectedIndex = index;
    if (self.configuration.isLazyLoadChildViews == true) {
        UIView *childView = [self.childViews objectAtIndex:index];
        UIView *contentView = [self.delegate swipeFlatView:self viewForItemAtIndex:index];
        NSAssert(contentView, @"View cannot be empty");
        [childView addSubview:contentView];
        [self layoutContentView:contentView atIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(swipeFlatView:willDisplayAtIndex:)]) {
        [self.delegate swipeFlatView:self willDisplayAtIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(swipeFlatView:didDisplayAtIndex:)]) {
        NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self.delegate swipeFlatView:self didDisplayAtIndex:index];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    _selectedIndex = selectedIndex;
    CGPoint point = CGPointMake(selectedIndex * self.scrollView.frame.size.width, 0);
    [self.scrollView setContentOffset:point animated:animated];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

@end
