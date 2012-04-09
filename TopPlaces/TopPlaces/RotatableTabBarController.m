//
//  RotatableViewController.m
//  Psychologist
//
//  Created by Jeremy Barth on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RotatableTabBarController.h"
#import "SplitViewBarButtonItemPresenter.h"

@implementation RotatableTabBarController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter {
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation 
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc 
{
    barButtonItem.title = self.title; // should be 'pyschologist'
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc 
    willShowViewController:(UIViewController *)aViewController 
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem 
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
