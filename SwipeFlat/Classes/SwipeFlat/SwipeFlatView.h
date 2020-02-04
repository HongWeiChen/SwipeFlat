//
//  SwipeFlatView.h
//  SwipeFlat
//
//  Created by Mystery on 2020/2/4.
//  Copyright © 2020 ChenHongWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeFlatConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SwipeFlatViewDelegate;

@interface SwipeFlatView : UIView

- (instancetype)initWithConfiguration:(SwipeFlatConfiguration *)configuration;

@property (weak, nonatomic) id<SwipeFlatViewDelegate>delegate;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end

@protocol SwipeFlatViewDelegate <NSObject>

@required
- (NSUInteger)numberOfCountForSwipeFlatView:(SwipeFlatView *)swipeFlatView;
- (UIView *)swipeFlatView:(SwipeFlatView *)swipeFlatView viewForItemAtIndex:(NSUInteger)index;

@optional
- (UIEdgeInsets)swipeFlatView:(SwipeFlatView *)swipeFlatView edgesForItemAtIndex:(NSUInteger)index;
- (void)swipeFlatView:(SwipeFlatView *)swipeFlatView willDisplayAtIndex:(NSUInteger)index;
- (void)swipeFlatView:(SwipeFlatView *)swipeFlatView didDisplayAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
