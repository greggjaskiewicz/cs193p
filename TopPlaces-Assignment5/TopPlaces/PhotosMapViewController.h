//
//  MapViewController.h
//  ShutterBug
//
//  Created by Jeremy Barth on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@class PhotosMapViewController;

@protocol PhotosMapViewControllerDelegate <NSObject>

- (UIImage *)photosMapViewController:(PhotosMapViewController *)sender imageForAnnoation:(id <MKAnnotation>)annotation;

@end

@interface PhotosMapViewController : MapViewController
@property (nonatomic, weak) id <PhotosMapViewControllerDelegate> delegate;
@end
