//
//  PhotographerTableViewController.m
//  Photomania
//
//  Created by Jeremy Barth on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotographerTableViewController.h"
#import "FlickrFetcher.h"
#import "Photo.h"
#import "Photo+Flickr.h"


@interface PhotographerTableViewController ()

@end

@implementation PhotographerTableViewController

@synthesize photoDatabase = _photoDatabase;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.photoDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Photo Database"];
        self.photoDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (void)setupFetchedResultsController {

}

- (void)fetchFlickrDataIntoDocument:(UIManagedDocument *)document {
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
        [document.managedObjectContext performBlock:^{
            for (NSDictionary *flickrInfo in photos) {
                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
            }
        }];
    });
    dispatch_release(fetchQ);
}

- (void)useDocument {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.photoDatabase.fileURL path]]) {
        [self.photoDatabase saveToURL:self.photoDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self fetchFlickrDataIntoDocument:self.photoDatabase];
        }];
    } else if (self.photoDatabase.documentState == UIDocumentStateClosed) {
        [self.photoDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.photoDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setPhotoDatabase:(UIManagedDocument *)photoDatabase {
    if (_photoDatabase != photoDatabase) {
        _photoDatabase = photoDatabase;
        [self useDocument];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Photographer Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

@end
