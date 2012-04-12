//
//  PhotosTableViewController.h
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *photos; // flickr photo dictionaries

-(void) assignTitle:(NSString *)title;

@end
