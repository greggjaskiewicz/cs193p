//
//  RecentPhotosTableViewController.m
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@implementation RecentPhotosTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentPhotos = [defaults objectForKey:RECENT_PHOTOS_KEY];
    self.photos = recentPhotos;
}

@end
