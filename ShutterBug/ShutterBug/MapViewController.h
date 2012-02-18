//
//  MapViewController.h
//  ShutterBug
//
//  Created by Jeremy Barth on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnoation:(id <MKAnnotation>)annotation;

@end

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@end
