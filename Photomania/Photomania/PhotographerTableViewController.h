//
//  PhotographerTableViewController.h
//  Photomania
//
//  Created by Jeremy Barth on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface PhotographerTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *photoDatabase;

@end
