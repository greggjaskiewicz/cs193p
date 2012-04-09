//
//  PlaceAnnotation.h
//  TopPlaces
//
//  Created by Jeremy Barth on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>

+ (PlaceAnnotation *)annotationForPlace:(NSDictionary *)place; // flickr place dictionary

@property (nonatomic, strong) NSDictionary *place;

@end
