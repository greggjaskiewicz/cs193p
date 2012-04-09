//
//  PlaceAnnotation.m
//  TopPlaces
//
//  Created by Jeremy Barth on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation PlaceAnnotation

@synthesize place = _place;

+ (PlaceAnnotation *)annotationForPlace:(NSDictionary *)place {
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

- (NSArray *)cityAndLocation {
    return [FlickrFetcher cityAndLocationForPlace:self.place];
}

- (NSString *)title {
    return [[self cityAndLocation] objectAtIndex:0];
}

- (NSString *)subtitle {
    return [[self cityAndLocation] objectAtIndex:1];
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
