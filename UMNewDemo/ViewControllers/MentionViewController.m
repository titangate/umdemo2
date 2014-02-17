//
//  MentionViewController.m
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import "MentionViewController.h"
#import "MentionTransitionAnimator.h"

@interface MentionViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) UIImageView *imageView;
@end

@implementation MentionViewController

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
}

- (void)viewDidLoad {
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"earthporn"]];
    [self.view addSubview:self.imageView];
}

+ (SOLEdge)randomEdge {
    return rand() % 8;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    toVC.transitioningDelegate = self;
    
    // use a random transition
    MentionTransitionAnimator *animator = [[MentionTransitionAnimator alloc] init];
    animator.edge = [MentionViewController randomEdge];
    return animator;
}

@end
