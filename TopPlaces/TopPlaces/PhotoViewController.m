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
#import "PhotoCache.h"

@interface PhotoViewController() <UIScrollViewDelegate> 
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize spinner = _spinner;

- (UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            _spinner.frame = CGRectMake(_spinner.frame.origin.x - 40, _spinner.frame.origin.y - 40, 80, 80);
            _spinner.backgroundColor = [UIColor blackColor];
            [self.view addSubview:_spinner];
        } else {
            _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    return _spinner;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem {
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)renderPhoto {
    UIView *titleView = self.navigationItem.titleView;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.navigationItem.titleView = self.spinner;
    }
    [self.spinner startAnimating];

    
    [GCD download:^{
        NSDictionary *downloadedPhoto = [self.photo copy];
        NSData *data = [PhotoCache fetchPhoto:self.photo];
        [GCD main:^{
            [self.spinner stopAnimating];
            if ([downloadedPhoto isEqualToDictionary:self.photo]) {
                self.navigationItem.titleView = titleView;
                UIImage *image = [UIImage imageWithData:data];
                self.imageView.image = image;
                self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                self.scrollView.contentSize = self.imageView.image.size;
            }
        }];
    }];
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
        [self renderPhoto];
    }
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self renderPhoto];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.imageView.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
