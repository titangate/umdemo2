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

@implementation MentionViewController {
    BOOL _interactionEnabled;
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
}

- (void)viewDidLoad {
    _interactionEnabled = YES;
    self.view.backgroundColor = [MentionViewController randomColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"earthporn"]];
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = [self defaultRectForMainView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.recognizer.delegate = self;
    [self.imageView addGestureRecognizer:self.recognizer];
}

- (BOOL)actionIsCompletedWithView:(UIView *)view velocity:(CGPoint)velocity {
    // assume as if the user retains the same velocity for another .1 second
    CGPoint finalPoint = CGPointMake(view.center.x + velocity.x * 0.1, view.center.y + velocity.y * 0.5);
    double progress = [self transitionIntervalForPoint:finalPoint inView:self.view];
    NSLog(@"Transition progress: %.2f", progress);
    return progress > 0.5;
}

- (double)transitionIntervalForPoint:(CGPoint)point inView:(UIView *)view {
    CGSize size = view.bounds.size;
    CGPoint center = view.center;
    double ix = fabs((point.x - center.x) * 2.0 / size.width);
    double iy = fabs((point.y - center.y) * 2.0 / size.height);
    return MAX(ix, iy);
}

- (void)startTransition {
    
}

- (CGRect)defaultRectForMainView {
    return CGRectMake(320/4, 568/4, 320/2, 568/2);
}

- (void)finishTransition:(BOOL)completed {
    if (completed) {
        
    } else {
        __block UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
        [self.animator addBehavior:behavior];
        _interactionEnabled = NO;
        // unfortunately apple did not supply a completion callback for UISnapBehavior. we will just assume it finishes
        // after 1 second.
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.animator removeBehavior:behavior];
            _interactionEnabled = YES;
        });
    }
}

- (void)updateTransitionWithInterval:(double)interval {
    
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
            CGPoint velocity = [recognizer velocityInView:self.view];
            BOOL completed = [self actionIsCompletedWithView:self.imageView velocity:velocity];
            [self finishTransition:completed];
            break;
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
