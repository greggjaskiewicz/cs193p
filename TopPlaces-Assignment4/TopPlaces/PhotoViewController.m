//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Jeremy Barth on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "GCD.h"

@interface PhotoViewController() <UIScrollViewDelegate> 
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)setPhoto:(NSDictionary *)photo {
    if (_photo != photo) {
        _photo = photo;
        self.navigationItem.title = [photo objectForKey:FLICKR_PHOTO_TITLE];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *recentPhotos = [[defaults objectForKey:RECENT_PHOTOS_KEY] mutableCopy];
        if (!recentPhotos) recentPhotos = [NSMutableArray array];
        [recentPhotos removeObject:photo];
        [recentPhotos insertObject:photo atIndex:0];
        [defaults setObject:recentPhotos forKey:RECENT_PHOTOS_KEY];
        [defaults synchronize];
    }
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [GCD download:^{
        NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [GCD main:^{
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.scrollView.contentSize = self.imageView.image.size;
        }];
    }];
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
