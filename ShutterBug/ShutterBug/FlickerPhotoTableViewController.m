//
//  FlickerPhotoTableViewController.m
//  ShutterBug
//
//  Created by Jeremy Barth on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickerPhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface FlickerPhotoTableViewController() <MapViewControllerDelegate>
@end

@implementation FlickerPhotoTableViewController

@synthesize photos = _photos;

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
            self.navigationItem.rightBarButtonItem = sender;
        });
    });
    dispatch_release(downloadQueue);
}

- (NSArray *)mapAnnoations {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)updateSplitViewDetail {
    id detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[MapViewController class]]) {
        MapViewController *mapVC = (MapViewController *)detail;
        mapVC.delegate = self;
        mapVC.annotations = [self mapAnnoations];
    }
}
- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnoation:(id<MKAnnotation>)annotation {
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

- (void)setPhotos:(NSArray *)photos {
    if (photos != _photos) {
        _photos = photos;
        [self updateSplitViewDetail];
        [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [photo objectForKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo objectForKey:FLICKR_PHOTO_OWNER];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
