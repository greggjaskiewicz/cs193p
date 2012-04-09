//
//  PlacesMapViewController.m
//  TopPlaces
//
//  Created by Jeremy Barth on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController() 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
@synthesize annotations = _annotations;
@synthesize mapView = _mapView;


- (void)updateMapView {
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
    }
}

- (void)setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations {
    _annotations = annotations;
    
    [self updateMapView];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
            viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    aView.annotation = annotation;
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
