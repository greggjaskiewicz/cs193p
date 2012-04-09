//
//  FlickrPhotoAnnotation.h
//  ShutterBug
//
//  Created by Jeremy Barth on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo; // flickr photo dictionary

@property (nonatomic, strong) NSDictionary *photo;

@end
