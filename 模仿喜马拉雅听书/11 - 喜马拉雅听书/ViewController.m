//
//  ViewController.m
//  11 - 喜马拉雅听书
//
//  Created by 董 尚先 on 13-12-7.
//  Copyright (c) 2013年 shangxianDante. All rights reserved.
//

#import "ViewController.h"

#define IMAGE_COUNT 5
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet UIButton *buttonUnder;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *midscrolView;
@property(nonatomic,strong) NSTimer *timer;

- (void)nextImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGFloat y = self.buttonUnder.frame.origin.y + self.buttonUnder.frame.size.height + 10;
    // 取出当前这个frame中 最大的Y值。
    CGFloat H = CGRectGetMaxY(self.buttonUnder.frame)+10;// $$$$$
    // 设置可以滚动到的最大的区域
    self.scrolView.contentSize = CGSizeMake(0, H);
    // 设置初次加载时的偏移量
    self.scrolView.contentOffset = CGPointMake(0, -64);
    // 设置四周在拉完一次后缩进多少 可以避开 头和尾
    self.scrolView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    
    CGFloat imgW = 0,imgH = 0,imgX = 0,imgY = 0;
    
    // 安规律插入imgView到 scrolView中
    for (int i = 0; i < IMAGE_COUNT; i++) {
        NSString *imgName = [NSString stringWithFormat:@"img_%02d",i+1];
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:imgName];
        
        [self.midscrolView addSubview:img];
        imgW = self.midscrolView.frame.size.width;
        imgH = self.midscrolView.frame.size.height;
        imgX = i * imgW;
        img.frame = CGRectMake(imgX, imgY, imgW, imgH);
    }
    CGFloat midscrolViewW = IMAGE_COUNT * imgW;
    self.midscrolView.contentSize =  CGSizeMake(midscrolViewW, 0);
    // 设置水平方向的的滚动条消失
    self.midscrolView.showsHorizontalScrollIndicator = NO;
    // 设置自动翻页功能为是
    self.midscrolView.pagingEnabled = YES;
    
    // 设置下面页角小点的数量和当前点
    self.pageControl.numberOfPages = IMAGE_COUNT;
    self.pageControl.currentPage = 0;
    
    // 设置定时器 这种方法的定时器必须加入主流程才能使用
    _timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];// $$$$$
}

#pragma mark - 代理方法正在移动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView // $$$$$
{
//    NSLog(@"正在滚动---%@", NSStringFromCGPoint(scrollView.contentOffset));
    int a = scrollView.contentOffset.x/self.midscrolView.frame.size.width + 0.5;
    self.pageControl.currentPage = a;
}

#pragma mark - 下一张图片方法
- (void)nextImage
{
    long int page = 0;// $$$$$$
    if (self.pageControl.currentPage == IMAGE_COUNT - 1) {
        page = 0;
    }else{
        page = self.pageControl.currentPage + 1;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
    self.midscrolView.contentOffset = CGPointMake(page * self.midscrolView.frame.size.width, 0);
    self.pageControl.currentPage = page;
    }];
}

#pragma mark - 代理方法刚刚拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self timerStop];
}

#pragma mark - 代理方法停止拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self timerStart];
}

#pragma mark - 计时器关闭
- (void)timerStop
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 计时器打开
- (void)timerStart
{
    _timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    // 此种方法必须添加到主运行循环才能开启
    // 如果用这种定时器可以不添加到主循环也能运行scheduledTimerWithTimeInterval: invocation: repeats:
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];// $$$$$
}

@end
