//
//  PlacesTableViewController.m
//  TopPlaces
//
//  Created by Jeremy Barth on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosTableViewController.h"
#import "GCD.h"

@implementation PlacesTableViewController

@synthesize places = _places;

- (NSArray *)cityAndLocationForPlace:(NSDictionary *)place {
    NSString *content = [place objectForKey:FLICKR_PLACE_NAME];
    int commaLocation = [content rangeOfString:@","].location;
    NSString *city = [content substringToIndex:commaLocation];
    NSString *location = [content substringFromIndex:commaLocation + 2];
    return [[NSArray alloc] initWithObjects:city, location, nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Top Place"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        id place = [self.places objectAtIndex:indexPath.row];
        NSString *city = [[self cityAndLocationForPlace:place] objectAtIndex:0];
        [GCD download:^{
            NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:50];
            [GCD main:^{
                [segue.destinationViewController setPhotos:photos];
                [segue.destinationViewController assignTitle:city];
            }];
        }];
    }
}

-(void)setPlaces:(NSArray *)places {
    if (places != _places) {
        _places = places;
        [self.tableView reloadData];
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [GCD download:^{
        NSArray *places = [FlickrFetcher topPlaces];
        [GCD main:^{
            self.places = places;
        }];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    NSArray *cityAndLocation = [self cityAndLocationForPlace:place];
    cell.textLabel.text = [cityAndLocation objectAtIndex:0];
    cell.detailTextLabel.text = [cityAndLocation objectAtIndex:1];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
