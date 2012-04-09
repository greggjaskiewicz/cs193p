//
//  PhotoCache.h
//  TopPlaces
//
//  Created by Jeremy Barth on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCache : NSObject
+ (NSData *)fetchPhoto:(NSDictionary *)photo;
+ (NSData *)fetchThumbnail:(NSDictionary *)photo;
@end
