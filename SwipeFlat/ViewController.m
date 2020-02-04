//
//  ViewController.m
//  SwipeFlat
//
//  Created by Mystery on 2020/2/4.
//  Copyright © 2020 ChenHongWei. All rights reserved.
//

#import "ViewController.h"
#import "SwipeFlatView.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"

@interface ViewController ()<SwipeFlatViewDelegate>

@property (strong, nonatomic) SwipeFlatView *swipeFlatView;
@property (strong, nonatomic) NSMutableArray *childViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.childViews = @[].mutableCopy;
    AViewController *a = [AViewController new];
    BViewController *b = [BViewController new];
    CViewController *c = [CViewController new];
    DViewController *d = [DViewController new];
    [self.childViews addObject:a.view];
    [self.childViews addObject:b.view];
    [self.childViews addObject:c.view];
    [self.childViews addObject:d.view];
    [self addChildViewController:a];
    [self addChildViewController:b];
    [self addChildViewController:c];
    [self addChildViewController:d];
    
    SwipeFlatConfiguration *conf = [[SwipeFlatConfiguration alloc] init];
    conf.isLazyLoadChildViews = true;
    self.swipeFlatView = [[SwipeFlatView alloc] initWithConfiguration:conf];
    [self.swipeFlatView setSelectedIndex:3 animated:NO];
    self.swipeFlatView.frame = self.view.bounds;
    self.swipeFlatView.delegate = self;
    [self.view addSubview:self.swipeFlatView];
}

- (NSUInteger)numberOfCountForSwipeFlatView:(SwipeFlatView *)swipeFlatView {
    return self.childViews.count;
}

- (UIView *)swipeFlatView:(SwipeFlatView *)swipeFlatView viewForItemAtIndex:(NSUInteger)index {
    return [self.childViews objectAtIndex:index];
}


@end
