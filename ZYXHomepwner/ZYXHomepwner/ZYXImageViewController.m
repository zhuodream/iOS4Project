//
//  ZYXImageViewController.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/4/8.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXImageViewController.h"

@interface ZYXImageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZYXImageViewController

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = self.image;
    self.imageView = imageView;
    
    scrollView.contentSize = imageView.bounds.size;
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2.0;
    [scrollView addSubview:self.imageView];
    self.view = scrollView;
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    
//    self.imageView.image = self.image;
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    
    scrollView.contentOffset = CGPointMake(self.imageView.bounds.size.width / 2 - scrollView.bounds.size.width/2, self.imageView.bounds.size.height / 2 - scrollView.bounds.size.height / 2);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"缩放的view");
    return self.imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"aaaaaaa");
    UIView *view = self.imageView;
    
    CGPoint offset = scrollView.contentOffset;
    
    if (view.bounds.size.width * scrollView.zoomScale < scrollView.bounds.size.width) {
        offset.x = (view.bounds.size.width * scrollView.zoomScale - scrollView.bounds.size.width)/2;
    }
    if (view.bounds.size.height * scrollView.zoomScale < scrollView.bounds.size.height) {
        offset.y = (view.bounds.size.height * scrollView.zoomScale - scrollView.bounds.size.height)/2;
    }
    
    scrollView.contentOffset = offset;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
