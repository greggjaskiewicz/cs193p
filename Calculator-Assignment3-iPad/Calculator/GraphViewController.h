//
//  GraphViewController.h
//  Calculator
//
//  Created by Jeremy Barth on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (strong, nonatomic) id program;

@end
