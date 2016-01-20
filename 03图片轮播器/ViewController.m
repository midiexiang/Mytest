//
//  ViewController.m
//  03图片轮播器
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ViewController.h"
#define count 5

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
//全局的时钟
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //指定代理
    self.scrollView.delegate=self;
    
    //获取当前ScrollView的宽度
    CGFloat width=self.scrollView.frame.size.width;
    //获取当前scrollView的高度
    CGFloat height=self.scrollView.frame.size.height;
    //循环添加UIImageView控件到ScrollView
    for(int i=0;i<count;i++)
    {
        UIImageView *imgView=[[UIImageView alloc] init];
        NSString *name=[NSString stringWithFormat:@"img_0%d",i+1];
        imgView.image=[UIImage imageNamed:name];
        //一定要设置控件的Frame
        CGFloat imgX=(i+1)*width;
        //0:说明在这个方向上不需要滚动
        imgView.frame=CGRectMake(imgX,0, width, height);
        //一定要记得将创建好的子控件添加到scrollView中
        [self.scrollView addSubview:imgView];
    }
    //1.在第一个图片位置添加最后一张图片
    UIImageView *firstImg=[[UIImageView alloc] init];
    firstImg.image=[UIImage imageNamed:@"img_05"];
    firstImg.frame=CGRectMake(0,0, width, height);
    [self.scrollView addSubview:firstImg];
    //2.那么现在需要显示的图片起始应该是第二张了
    self.scrollView.contentOffset=CGPointMake(width, 0);
    //3.设置pageControl的currentPage=0
    self.pageView.currentPage=0;
    //4.添加第一张图片到最后的位置
    UIImageView *lastImg=[[UIImageView alloc] init];
    lastImg.image=[UIImage imageNamed:@"img_01"];
    lastImg.frame=CGRectMake((count+1)*width,0, width, height);
    [self.scrollView addSubview:lastImg];
    
    
    //要ScrollView滚起来，就要设置contentSize
    self.scrollView.contentSize=CGSizeMake((count+2)*width, 0);
    //设置没有水平滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    //设置scrollView的分页滚动效果：每一次滚动的距离就是scrollView的宽度
    self.scrollView.pagingEnabled=YES;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
    //创建消息循环
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    //将时钟添加到这个循环中 ：NSRunLoopCommonModes：是指循环处理每一个操作，同时处理，分配时间来执行消息循环中每一个操作
    //NSDefaultRunLoopMode:如果在执行一个操作，就不能同时执行另外一个操作。只有做完一个操作之后才会进行另外一个操作。
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//下一张图片
- (void) nextImg
{
    CGFloat width=self.scrollView.frame.size.width;
    //获取当前索引
    NSInteger index=self.pageView.currentPage;
    //判断索引是否是最后一张
    if(index==count)
    {
        index=0;
    }
    else
    {
        index++;
    }
    //重点是修改ScrollView的contentOffset值，只有它才可以让scrollView进行偏移
    [self.scrollView setContentOffset:CGPointMake((index+1)*width, 0) animated:YES];
}

//在滚动过程中，计算出pageControl的索引值.scollView的滚动会触发当前这个方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width=self.scrollView.frame.size.width; //300
    //计算pageControl索引
    int index=(self.scrollView.contentOffset.x+width*0.5)/width; //300
    if(index==count+1)
    {
        index=1;
    }
    else if(index==0)
    {
        index=count;
    }
    //指定索引
    self.pageView.currentPage=index-1;
}

//需要实现一个效果：当用户拖拽图片的时候，图片不要再继续滚动了，而是停止，等用户松开鼠标后继续滚动
//1.为什么拖拽后还会继续滚动：因为有时钟,所以我们需要将时钟停止
//2.所以需要创建全局的时钟
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止时钟：只能销毁
    [self.timer invalidate];
    self.timer=nil;
}

//松开鼠标后，重新创建时钟，开启时钟
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
    //创建消息循环
    NSRunLoop *runloop=[NSRunLoop currentRunLoop];
    //将时钟添加到这个循环中 ：NSRunLoopCommonModes：是指循环处理每一个操作，同时处理，分配时间来执行消息循环中每一个操作
    //NSDefaultRunLoopMode:如果在执行一个操作，就不能同时执行另外一个操作。只有做完一个操作之后才会进行另外一个操作。
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//当滚动动画停止时触发--setContentOffset   animated
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width=self.scrollView.frame.size.width;
    int index=(self.scrollView.contentOffset.x+width*0.5)/width;
    if(index==count+1)
    {
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }
    else if(index==0)
    {
        [self.scrollView setContentOffset:CGPointMake(count*width, 0) animated:NO];
    }
}
@end






