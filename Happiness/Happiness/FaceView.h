//
//  FaceView.h
//  Happiness
//
//  Created by Jeremy Barth on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView;

@protocol FaceViewDataSource
- (float)smileForFaceView:(FaceView *)sender;
@end

@interface FaceView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end

