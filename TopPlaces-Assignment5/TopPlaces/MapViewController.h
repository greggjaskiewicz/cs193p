//
//  PlacesMapViewController.h
//  TopPlaces
//
//  Created by Jeremy Barth on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@end
