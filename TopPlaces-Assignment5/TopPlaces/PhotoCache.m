//
//  PhotoCache.m
//  TopPlaces
//
//  Created by Jeremy Barth on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCache.h"
#import "FlickrFetcher.h"

@implementation PhotoCache

+ (unsigned long long) sizeOfFilesIn:(NSURL *)path using:(NSFileManager *)fileManager {
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:[path path]];
    NSString *file;
    long totalSize = 0;
    while (file = [dirEnum nextObject]) {
        NSError *error;
        if ([file hasSuffix:@"jpg"]) {
            totalSize += [[fileManager attributesOfItemAtPath:[[path URLByAppendingPathComponent:file] path] error:&error] fileSize];
        }
    }
    return totalSize;
}

+ (NSString *) oldestFileIn:(NSURL *)path using:(NSFileManager *)fileManager {
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:[path path]];
    NSString *file;
    NSString *oldestFile;
    NSDate *oldestDate;
    while (file = [dirEnum nextObject]) {
        NSError *error;
        NSString *filePath = [[path URLByAppendingPathComponent:file] path];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
        if ([file hasSuffix:@"jpg"]) {
            NSDate *modDate = [attributes fileModificationDate];
            if (oldestDate == nil || [modDate compare:oldestDate] == NSOrderedAscending) {
                oldestDate = modDate;
                oldestFile = filePath;
            }
            NSLog(@"file: %@ -- mod date: %@", file, modDate);
        }
    }
    return oldestFile;
}

+(NSData *)fetchPhoto:(NSDictionary *)photo format:(int)format {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *cachePath = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [FlickrFetcher urlForPhoto:photo format:format];
    if (!url) return nil;
    NSString *dir = [[url pathComponents] objectAtIndex:[[url pathComponents] count] - 2]; 
    NSURL *path = [cachePath URLByAppendingPathComponent:dir];
    NSURL *filePath = [path URLByAppendingPathComponent:[url lastPathComponent]];
    
    NSData *image;
    NSError *error;
    if (![fileManager fileExistsAtPath:[filePath path]]) {
        // create directory
        if (![fileManager createDirectoryAtURL:path 
                   withIntermediateDirectories:YES 
                                    attributes:nil 
                                         error:&error]) {
            NSLog(@"failed: %@", error);
        } else {
            // create file
            if (![[NSData dataWithContentsOfURL:url] writeToURL:filePath options:NSDataWritingAtomic error:&error]) {
                NSLog(@"failed: %@", error);
            }
            NSLog(@"create file %@", [filePath path]);
        }
    } else {
        NSDictionary* modDict = [NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate];
        NSLog(@"update mod date of %@", [filePath path]);
        if (![fileManager setAttributes:modDict ofItemAtPath:[filePath path] error:&error]) {
            NSLog(@"Unable to update modification date of file: %@", [error localizedDescription]);
        }
    }
    
    image = [fileManager contentsAtPath:[filePath path]];

    while ([self sizeOfFilesIn:cachePath using:fileManager] > 10485760) {
        NSString *file = [PhotoCache oldestFileIn:cachePath using:fileManager];
        NSLog(@"removing file %@", file);
        if (![fileManager removeItemAtPath:file error:&error]) {
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
    }

    return image;
}

+ (NSData *)fetchPhoto:(NSDictionary *)photo {
    return [PhotoCache fetchPhoto:photo format:FlickrPhotoFormatOriginal];
}

+ (NSData *)fetchThumbnail:(NSDictionary *)photo {
    return [PhotoCache fetchPhoto:photo format:FlickrPhotoFormatSquare];
}

@end
