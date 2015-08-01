//
//  JYAdvertiseView.m
//  JYAdvertisementDisplay
//
//  Created by fangjiayou on 15/7/30.
//  Copyright (c) 2015年 方. All rights reserved.
//

#import "JYAdvertiseView.h"

static const NSInteger kAdvertiseCount = 4;//广告的个数
static const CGFloat scrollY = 20;
static const CGFloat pageCtrlWidth = 200;

@interface JYAdvertiseView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,strong) NSArray *dataSources;

@property(nonatomic,assign) CGRect aFrame;

@end

@implementation JYAdvertiseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _aFrame = frame;
        [self initScrollView];
        [self addTimer];
    }
    return self;
}

#pragma mark - init
/*!
 *  @author FJY
 *
 *  @brief  初始化滑动控件
 */
- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollY, CGRectGetWidth(_aFrame), CGRectGetHeight(_aFrame)-scrollY)];
    self.scrollView.delegate = self;
    for (int i = 0; i<kAdvertiseCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetWidth(_aFrame)*i, 0, CGRectGetWidth(_aFrame), CGRectGetHeight(_aFrame));
        btn.tag = i;
//        [btn setBackgroundImage:[UIImage imageNamed:@"advertise"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1.0];
        [btn addTarget:self action:@selector(advertiseViewSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(_aFrame)*kAdvertiseCount, CGRectGetHeight(_aFrame)-20);
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    [self insertSubview:self.pageControl aboveSubview:self.scrollView];
}

/*!
 *  @author FJY
 *
 *  @brief  初始化PageControl
 */
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(_aFrame)-pageCtrlWidth)*0.5, (CGRectGetHeight(_aFrame)-scrollY), pageCtrlWidth, scrollY)];
        _pageControl.numberOfPages = kAdvertiseCount;
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    }
    return _pageControl;
}

/*!
 *  @author FJY
 *
 *  @brief  初始化计时器
 *
 *  @return 计时器
 */
- (NSTimer*)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - private
/*!
 *  @author FJY
 *
 *  @brief  添加计时器
 */
- (void)addTimer
{
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/*!
 *  @author FJY
 *
 *  @brief  跳转到下一页
 */
- (void)nextPage
{
    NSInteger page = self.pageControl.currentPage;
    page++;
    CGPoint point = CGPointMake(CGRectGetWidth(_aFrame)*(page%kAdvertiseCount), scrollY);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.scrollView.contentOffset = point;
    } completion:^(BOOL finished) {
        
    }];
    //    NSLog(@"page = %@ ",@(page));
}


/*!
 *  @author FJY
 *
 *  @brief  移除计时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加0.5是为了当前页面有两张图片的时候，滑动到下一张
    NSInteger page = scrollView.contentOffset.x/CGRectGetWidth(_aFrame) + 0.5;
    [UIView animateWithDuration:0.5f animations:^{
        self.pageControl.currentPage = page;
    } completion:^(BOOL finished) {
        
    }];
    
}

//当试图将要拖动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //手动拖动时候停掉计时器
    [self removeTimer];
}

//当视图停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //停止拖动后2秒开始计时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addTimer];
    });
}

#pragma mark - Action
/*!
 *  @author FJY
 *
 *  @brief  单个广告点击
 *
 *  @param sender 点击控件
 */
- (void)advertiseViewSelected:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(advertiseView:didSelectedIndex:)]) {
        [self.delegate advertiseView:self didSelectedIndex:self.pageControl.currentPage];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
