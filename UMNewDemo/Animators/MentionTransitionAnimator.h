//
//  MentionTransitionAnimator.h
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SOLEdge) {
    SOLEdgeTop,
    SOLEdgeLeft,
    SOLEdgeBottom,
    SOLEdgeRight,
    SOLEdgeTopRight,
    SOLEdgeTopLeft,
    SOLEdgeBottomRight,
    SOLEdgeBottomLeft
};

@interface MentionTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) SOLEdge edge;
@property (nonatomic, assign, getter = isAppearing) BOOL appearing;

+ (NSDictionary *)edgeDisplayNames;

- (CGRect)rectOffsetFromRect:(CGRect)rect atEdge:(SOLEdge)edge;

@end
