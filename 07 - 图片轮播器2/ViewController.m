//
//  ViewController.m
//  07 - 图片轮播器2
//
//  Created by 肖晨 on 15/7/16.
//  Copyright (c) 2015年 肖晨. All rights reserved.
//

#import "ViewController.h"
#define kImageCount 5

@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)UIPageControl *pageControl;
@property (strong, nonatomic)NSTimer *timer;

@end

@implementation ViewController

- (void)startTimer
{
        _timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerChange
{
    NSLog(@"%@", _timer);
    NSUInteger page = (self.pageControl.currentPage +1)% kImageCount;
    self.pageControl.currentPage = page;
    [self pageChanged:self.pageControl];
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = kImageCount;
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        CGSize size = [_pageControl sizeForNumberOfPages:kImageCount];
        _pageControl.frame = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.bounds.size.width * 0.5, 130);
        
        [self.view addSubview:_pageControl];
        
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageChanged:(UIPageControl *)page
{
//    NSLog(@"%d", page.currentPage);
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, (self.view.bounds.size.width - 20) * 0.45)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kImageCount * _scrollView.bounds.size.width, 0);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < kImageCount; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"img_%02d.png",i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image = image;
        
        [self.scrollView addSubview:imageView];
    }
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        imageView.frame = frame;
    }];
    
    self.pageControl.currentPage = 0;
    
    [self startTimer];
    
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

@end
