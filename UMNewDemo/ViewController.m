//
//  ViewController.m
//  UMNewDemo
//
//  Created by Nanyi Jiang on 2/16/2014.
//  Copyright (c) 2014 Nanyi Jiang. All rights reserved.
//

#import "ViewController.h"
#import "MentionViewController.h"

@interface ViewController () <MentionViewControllerDelegate>
@property (nonatomic) NSMutableArray *viewControllers;
@end

@implementation ViewController

- (MentionViewController *)createNewMentionViewControllerAtIndex:(NSInteger)index {
    MentionViewController *controller = [[MentionViewController alloc] init];
    [controller setImage:[UIImage imageNamed:@"earthporn"]];
    [controller setText:[NSString stringWithFormat:@"This is the %dth mention", index]];
    controller.delegate = self;
    [self.viewControllers addObject:controller];
    return controller;
}

- (void)viewDidLoad {
    self.viewControllers = [[NSMutableArray alloc] init];
    MentionViewController *controller = [self createNewMentionViewControllerAtIndex:0];
    [self.navigationController pushViewController:controller animated:YES];
    self.navigationController.delegate = controller;
}

- (BOOL)nextOneReady {
    return YES;
}

- (UIViewController *)nextViewController {
    NSLog(@"new vc %d", [self.viewControllers count]);
    return [self createNewMentionViewControllerAtIndex:[self.viewControllers count]];
}

@end
