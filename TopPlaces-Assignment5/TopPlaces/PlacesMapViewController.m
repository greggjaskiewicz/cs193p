//
//  PlacesMapViewController.m
//  TopPlaces
//
//  Created by Jeremy Barth on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesMapViewController.h"
#import "PlacesTableViewController.h"
#import "PlaceAnnotation.h"

@implementation PlacesMapViewController


- (void)                mapView:(MKMapView *)mapView 
                 annotationView:(MKAnnotationView *)view 
  calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"MapPhotos" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapPhotos"]) {
        MKAnnotationView *mkav = (MKAnnotationView *)sender;
        PlaceAnnotation *pa = (PlaceAnnotation *)mkav.annotation;
        [PlacesTableViewController prepareForSegue:segue sender:sender place:pa.place];
    }
}

@end
