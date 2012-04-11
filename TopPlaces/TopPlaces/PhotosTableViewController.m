//
//  PhotosTableViewController.m
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "GCD.h"
#import "PhotoViewController.h"
#import "PhotosMapViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "PhotoCache.h"


@interface PhotosTableViewController() <PhotosMapViewControllerDelegate>
@end

@implementation PhotosTableViewController

@synthesize photos = _photos;

- (UIImage *)photosMapViewController:(PhotosMapViewController *)sender imageForAnnoation:(id<MKAnnotation>)annotation {
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    return [UIImage imageWithData:[PhotoCache fetchThumbnail:fpa.photo]];
}

- (NSArray *)mapAnnoations {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo];
    } else if ([segue.identifier isEqualToString:@"PhotosMap"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setAnnotations:[self mapAnnoations]];
    }
    
}

-(void)assignTitle:(NSString *)title {
    // TODO check if empty
    self.navigationItem.title = title;  
}

-(void)setPhotos:(NSArray *)photos {
    if (_photos != photos) {
        _photos = photos;
        [self.tableView reloadData];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    static NSString *CellIdentifier = @"Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title isEqualToString:@""]) {
        title = [subtitle copy];
        subtitle = @"";
        if ([title isEqualToString:@""]) {
            title = @"Unknown";
        }
    }
    [GCD download:^{
        UIImage *image = [UIImage imageWithData:[PhotoCache fetchThumbnail:photo]];
        UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
        if ([[tableView visibleCells] containsObject: theCell]) {
            [GCD main:^{
                theCell.imageView.image = image;
                [theCell setNeedsLayout];
            }];
        }
    }];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

- (PhotoViewController *)splitViewPhotoViewController {
    id pvc = [self.splitViewController.viewControllers lastObject];
    if (![pvc isKindOfClass:[PhotoViewController class]]) pvc = nil;
    return pvc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self splitViewPhotoViewController].photo = [self.photos objectAtIndex:indexPath.row];
}

@end
