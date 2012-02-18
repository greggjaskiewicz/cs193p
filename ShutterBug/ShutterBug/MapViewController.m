//
//  MapViewController.m
//  ShutterBug
//
//  Created by Jeremy Barth on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/Mapkit.h>

@interface MapViewController() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

- (void)updateMapView {
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations {
    _annotations = annotations;
    [self updateMapView];
}

#pragma mark - View lifecycle

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    dispatch_queue_t downloadQueue = dispatch_queue_create("download queue", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image = [self.delegate mapViewController:self imageForAnnoation:view.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
        });
    });
    dispatch_release(downloadQueue);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
            viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

@end
