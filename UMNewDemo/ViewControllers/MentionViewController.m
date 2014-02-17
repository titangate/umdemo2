//
//  MentionViewController.m
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import "MentionViewController.h"
#import "MentionTransitionAnimator.h"

@interface MentionViewController () <UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIPanGestureRecognizer *recognizer;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@end

@implementation MentionViewController

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
}

- (void)viewDidLoad {
    self.view.backgroundColor = [MentionViewController randomColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"earthporn"]];
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.bounds = CGRectMake(10, 10, 320/2, 568/2);
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.recognizer.delegate = self;
    [self.imageView addGestureRecognizer:self.recognizer];
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (self.attachmentBehavior == nil) {
                // the view might be rotated. we apply a rotational matrix to calculate the correct offset.
                // the angle is the opposite to the rotation of the view.
                // we can also view it as the inverse of the original rotational matrix.
                CGAffineTransform transform = self.imageView.transform;
                CGFloat angle = -atan2f(transform.b, transform.a);
                CGFloat c = cosf(angle);
                CGFloat s = sinf(angle);
                CGFloat dx = location.x - self.imageView.center.x;
                CGFloat dy = location.y - self.imageView.center.y;
                UIOffset offset = UIOffsetMake(c * dx - s * dy, s * dx + c * dy);
                self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.imageView offsetFromCenter:offset attachedToAnchor:location];
                [self.animator addBehavior:self.attachmentBehavior];
            }
        case UIGestureRecognizerStateChanged:
            [self.attachmentBehavior setAnchorPoint:location];
            break;
        case UIGestureRecognizerStateEnded:
            [self.animator removeBehavior:self.attachmentBehavior];
            self.attachmentBehavior = nil;
        default:
            break;
    }
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

#pragma mark UIGestureRecognizerDelegate methods

@end
