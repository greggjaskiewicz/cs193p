//
//  Downloader.h
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCD : NSObject

+ (void) download:(void(^)())block;
+ (void) main:(void(^)())block;

@end
