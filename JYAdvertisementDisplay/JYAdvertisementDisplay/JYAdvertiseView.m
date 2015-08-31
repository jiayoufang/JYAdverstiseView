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

@property(nonatomic,assign) NSInteger cuttentPage;

@end

@implementation JYAdvertiseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _aFrame = frame;
//        [self initScrollView];
//        [self addTimer];
        
        _dataSources = @[[UIColor redColor],[UIColor colorWithRed:0.923 green:1.000 blue:0.655 alpha:1.000],[UIColor colorWithRed:0.568 green:1.000 blue:0.416 alpha:1.000],[UIColor colorWithRed:0.220 green:0.295 blue:1.000 alpha:1.000],[UIColor colorWithRed:0.944 green:0.339 blue:1.000 alpha:1.000],[UIColor colorWithRed:0.445 green:1.000 blue:0.929 alpha:1.000],[UIColor colorWithRed:1.000 green:0.211 blue:0.816 alpha:1.000]];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.cuttentPage = 0;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self addTimer];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            imageView.frame = CGRectMake(imageView.tag * width, 0, width, height);
        }
    }
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(width * 3, height);
    self.scrollView.contentOffset = CGPointMake(width, 0);
}

#pragma mark - Getter Init

/*!
 *  @author FJY
 *
 *  @brief  初始化ScrollView
 */
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.tag = i;
            [_scrollView addSubview:imageView];
        }
    }
    return _scrollView;
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
        _pageControl.numberOfPages = _dataSources.count;
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
    CGPoint offSet = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), 0);
    [self.scrollView setContentOffset:offSet animated:YES];
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

- (NSInteger)getNextPageIndexWithPageIndex:(NSInteger)currentIndex
{
    NSInteger index;
    if (currentIndex == -1) {
        index = _dataSources.count - 1;
    }
    else if (currentIndex == _dataSources.count){
        index = 0;
    }
    else{
        index = currentIndex;
    }
    return index;
}

- (void)showCurrentImages
{
    if (_dataSources.count == 0) {
        return;
    }
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            UIColor *color = [self getImageBackgroundColor:imageView.tag];
            imageView.backgroundColor = color;
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
}

- (UIColor *)getImageBackgroundColor:(NSInteger)tag
{
    NSInteger index = [self getNextPageIndexWithPageIndex:self.cuttentPage + (tag - 1)];
    return [_dataSources objectAtIndex:index];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = [self getNextPageIndexWithPageIndex:self.cuttentPage];
    if (scrollView.contentOffset.x >= 2*CGRectGetWidth(scrollView.frame)) {
        self.cuttentPage = [self getNextPageIndexWithPageIndex:self.cuttentPage + 1];
        [self showCurrentImages];
    }
    
    if (scrollView.contentOffset.x <= 0) {
        self.cuttentPage = [self getNextPageIndexWithPageIndex:self.cuttentPage - 1];
        [self showCurrentImages];
    }
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
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
