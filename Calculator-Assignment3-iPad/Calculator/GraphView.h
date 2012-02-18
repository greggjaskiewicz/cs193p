//
//  GraphView.h
//  Calculator
//
//  Created by Jeremy Barth on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (CGFloat)y:(CGFloat)x;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tripleTap:(UITapGestureRecognizer *)gesture;

@end
