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

@implementation PhotosTableViewController

@synthesize photos = _photos;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Photo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo];
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
    NSString *subtitle = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    if ([title isEqualToString:@""]) {
        title = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
        subtitle = @"";
        if ([title isEqualToString:@""]) {
            title = @"Unknown";
        }
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

@end
