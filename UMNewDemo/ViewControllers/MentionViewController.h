//
//  MentionViewController.h
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MentionViewControllerDelegate <NSObject>

- (BOOL)nextOneReady;
- (UIViewController *)nextViewController;

@end

@interface MentionViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, weak) id<MentionViewControllerDelegate> delegate;
- (void)setImage:(UIImage *)image;
- (void)setText:(NSString *)text;

@end
