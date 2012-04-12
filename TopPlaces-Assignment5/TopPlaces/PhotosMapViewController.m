//
//  MapViewController.m
//  ShutterBug
//
//  Created by Jeremy Barth on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosMapViewController.h"
#import "GCD.h"
#import "FlickrPhotoAnnotation.h"
#import "PhotoViewController.h"

@interface PhotosMapViewController()
@end

@implementation PhotosMapViewController
@synthesize delegate = _delegate;


#pragma mark - View lifecycle

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [GCD download:^{
        UIImage *image = [self.delegate photosMapViewController:self imageForAnnoation:view.annotation];
        [GCD main:^{
            [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
        }];
    }];
}

- (PhotoViewController *)splitViewPhotoViewController {
    id pvc = [self.splitViewController.viewControllers lastObject];
    if (![pvc isKindOfClass:[PhotoViewController class]]) pvc = nil;
    return pvc;
}


- (void)                mapView:(MKMapView *)mapView 
                 annotationView:(MKAnnotationView *)view 
  calloutAccessoryControlTapped:(UIControl *)control {
    if ([self splitViewPhotoViewController]) {
        FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)view.annotation;
        [self splitViewPhotoViewController].photo = fpa.photo;
    } else {
        [self performSegueWithIdentifier:@"MapPhoto" sender:view];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapPhoto"]) {
        MKAnnotationView *mkav = (MKAnnotationView *)sender;
        FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)mkav.annotation;
        [segue.destinationViewController setPhoto:fpa.photo];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView 
            viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aView = [super mapView:mapView viewForAnnotation:annotation];
    aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    return aView;
}

@end
