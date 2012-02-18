//
//  HappinessViewController.h
//  Happiness
//
//  Created by Jeremy Barth on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface HappinessViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic) int happiness; // sad 0 - 100 happy

@end
