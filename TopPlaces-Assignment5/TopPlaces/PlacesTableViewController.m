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
#import "PlaceAnnotation.h"
#import "MapViewController.h"

@implementation PlacesTableViewController

@synthesize places = _places;


- (NSArray *)mapAnnoations {
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.places count]];
    for (NSDictionary *place in self.places) {
        [annotations addObject:[PlaceAnnotation annotationForPlace:place]];
    }
    return annotations;
}

+ (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender place:(NSDictionary *)place {
    NSString *city = [[FlickrFetcher cityAndLocationForPlace:place] objectAtIndex:0];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    UIView *titleView = [segue.destinationViewController navigationItem].titleView;
    [segue.destinationViewController navigationItem].titleView = spinner;
    
    [GCD download:^{
        NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:50];
        [GCD main:^{
            [spinner stopAnimating];
            [segue.destinationViewController setPhotos:photos];
            [segue.destinationViewController navigationItem].titleView = titleView;
            [segue.destinationViewController assignTitle:city];
        }];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Top Place"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        id place = [self.places objectAtIndex:indexPath.row];
        [PlacesTableViewController prepareForSegue:segue sender:sender place:place];
    } else if ([segue.identifier isEqualToString:@"PlacesMap"]) {
        [segue.destinationViewController setAnnotations:[self mapAnnoations]];
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
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];

    UIView *titleView = self.navigationItem.titleView;
    self.navigationItem.titleView = spinner;
    
    [GCD download:^{
        NSArray *places = [FlickrFetcher topPlaces];
        [GCD main:^{
            [spinner stopAnimating];
            self.navigationItem.titleView = titleView;
            self.places = places;
        }];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    NSArray *cityAndLocation = [FlickrFetcher cityAndLocationForPlace:place];
    cell.textLabel.text = [cityAndLocation objectAtIndex:0];
    cell.detailTextLabel.text = [cityAndLocation objectAtIndex:1];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
