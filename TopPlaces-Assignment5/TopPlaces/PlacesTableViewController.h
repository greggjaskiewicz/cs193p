//
//  PlacesTableViewController.h
//  TopPlaces
//
//  Created by Jeremy Barth on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlacesTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *places;
+ (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender place:(NSDictionary *)place;
@end
