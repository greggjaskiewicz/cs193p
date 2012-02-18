//
//  GraphViewController.m
//  Calculator
//
//  Created by Jeremy Barth on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController() <GraphViewDataSource>

@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *function;

@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize function = _function;

@synthesize program = _program;

-(void)setProgram:(id)program {
    _program = program;
    [self.graphView setNeedsDisplay];
}

-(void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tripleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tripleTapGestureRecognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tripleTapGestureRecognizer];
    self.graphView.dataSource = self;
}

-(CGFloat)y:(CGFloat)x {
    return [CalculatorBrain runProgram:self.program usingVariables:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.function.text = [NSString stringWithFormat:@"y = %@", [CalculatorBrain descriptionOfProgram:self.program]];
}       

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setGraphView:nil];
    [self setFunction:nil];
    [super viewDidUnload];
}
@end
