//
//  PhotoViewController.h
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECENT_PHOTOS_KEY @"PhotoViewController.RecentPhotos"

@interface PhotoViewController : UIViewController
@property (nonatomic, strong) NSDictionary *photo; // flickr photo

@end
