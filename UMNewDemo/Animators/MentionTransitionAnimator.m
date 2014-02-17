//
//  MentionTransitionAnimator.m
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import "MentionTransitionAnimator.h"

@implementation MentionTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

#pragma mark - UIViewControllerAnimatedTransitioning


// This method can only be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    toView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [containerView insertSubview:toView belowSubview:fromView];
    toView.alpha = 0.5;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         BOOL completed = toView.alpha == 1;
                         [transitionContext completeTransition:completed];
                     }];
}

@end
