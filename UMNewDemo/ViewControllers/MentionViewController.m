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
@property (nonatomic) UILabel *textView;
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIPanGestureRecognizer *recognizer;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) MentionTransitionAnimator *transitionAnimator;
@property (nonatomic) UIViewController *nextVC;
@end

@implementation MentionViewController {
    BOOL _interactionEnabled;
    NSString *_text;
    UIImage *_image;
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)viewDidLoad {
    _interactionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] initWithImage:_image];
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = [self defaultRectForMainView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.recognizer.delegate = self;
    
    self.textView = [[UILabel alloc] initWithFrame:self.imageView.bounds];
    self.textView.numberOfLines = 0;
    self.textView.userInteractionEnabled = NO;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.text = _text;
    self.textView.backgroundColor = [UIColor clearColor];
    [self.imageView addGestureRecognizer:self.recognizer];
    
    [self.imageView addSubview:self.textView];
}

- (BOOL)actionIsCompletedWithView:(UIView *)view velocity:(CGPoint)velocity {
    // assume as if the user retains the same velocity for another .1 second
    CGPoint finalPoint = CGPointMake(view.center.x + velocity.x * 0.1, view.center.y + velocity.y * 0.1);
    double progress = [self transitionIntervalForPoint:finalPoint inView:self.view];
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
    NSAssert([self.delegate nextOneReady], @"No more views in transition!");
    if (!self.nextVC) {
        self.nextVC = [self.delegate nextViewController];
    }
    [self.navigationController pushViewController:self.nextVC animated:YES];
}

- (CGRect)defaultRectForMainView {
    return CGRectMake(320/4, 568/4, 320/2, 568/2);
}

- (void)finishTransition:(BOOL)completed {
    if (completed) {
        [self.transitionAnimator finishInteractiveTransition];
        self.navigationController.delegate = self.nextVC;
        
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObject:self.imageView]];
        CGFloat dx = (self.imageView.center.x - self.view.center.x) * 10;
        CGFloat dy = (self.imageView.center.y - self.view.center.y) * 10;
        [itemBehavior addLinearVelocity:CGPointMake(dx, dy) forItem:self.imageView];
        [self.animator addBehavior:itemBehavior];
    } else {
        [self.transitionAnimator cancelInteractiveTransition];
        CGRect rect = [self defaultRectForMainView];
        CGPoint targetPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        __block UISnapBehavior *behavior = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:targetPoint];
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
    [self.transitionAnimator updateInteractiveTransition:interval];
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (![self.delegate nextOneReady]) {
                return;
            }
            [self startTransition];
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
            double progress = [self transitionIntervalForPoint:self.imageView.center inView:self.view];
            [self updateTransitionWithInterval:progress];
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

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        toVC.transitioningDelegate = self;
        
        // use a random transition
        MentionTransitionAnimator *animator = [[MentionTransitionAnimator alloc] init];
        self.transitionAnimator = animator;
        return animator;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController == self.transitionAnimator) {
        
        return self.transitionAnimator;
    }
    return nil;
}

#pragma mark UIGestureRecognizerDelegate methods

@end
