//
//  Downloader.m
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCD.h"

@implementation GCD

+(void)download:(void (^)())block {
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, block);
    dispatch_release(downloadQueue);
}

+(void)main:(void (^)())block {
    dispatch_async(dispatch_get_main_queue(), block);
}
@end
