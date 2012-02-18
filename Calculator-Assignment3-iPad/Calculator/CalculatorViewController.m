//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jeremy Barth on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController()

@property (nonatomic) BOOL enteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL enteredADecimalPoint;
@property (nonatomic, strong) NSDictionary *testVariableValues;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize enteringANumber = _enteringANumber;
@synthesize brain = _brain;
@synthesize enteredADecimalPoint = _enteredADecimalPoint;
@synthesize testVariableValues = _testVariableValues;
@synthesize variablesUsed = _variablesUsed;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [CalculatorBrain new];
    return _brain;
}

- (NSDictionary *)testVariableValues {
    if (!_testVariableValues) _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], @"x", 
                               [NSNumber numberWithInt:2], @"y", 
                               [NSNumber numberWithInt:3], @"z", nil];
    return _testVariableValues;
}

- (IBAction)graph {
    [[self.splitViewController.viewControllers lastObject] setProgram:self.brain.program];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setProgram:self.brain.program];
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.history.text = @"";
    self.variablesUsed.text = @"";
    self.enteringANumber = NO;
    self.enteredADecimalPoint = NO;
    [self.brain clear];
    self.testVariableValues = nil;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.enteringANumber) {
        self.display.text = 
            [self.display.text stringByAppendingString:sender.currentTitle];
    } else if (![sender.currentTitle isEqualToString:@"0"]) {
        self.enteringANumber = YES;
        self.display.text = sender.currentTitle;
    }
}

- (IBAction)decimalPressed {
    if (self.enteringANumber) {
        if (!self.enteredADecimalPoint) {
            self.enteredADecimalPoint = YES;
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.enteringANumber = YES;
        self.enteredADecimalPoint = YES;
        self.display.text = @"0.";
    }
}

- (IBAction)backspacePressed {
    if (self.display.text.length == 1) {
        self.display.text = @"0";
        self.enteringANumber = NO;
        self.enteredADecimalPoint = NO;
    } else {
        int lastIndex = self.display.text.length - 1;
        NSString *lastChar = [self.display.text substringFromIndex:lastIndex];
        if ([lastChar isEqualToString:@"."]) {
            self.enteredADecimalPoint = NO;
            if ([self.display.text isEqualToString:@"0."]) {
                self.enteringANumber = NO;
            }
        }
        self.display.text = [self.display.text substringToIndex:lastIndex];
    }
}

- (void)updateLabels {
    self.display.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.brain.program usingVariables:self.testVariableValues]];
    
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    self.variablesUsed.text = @"";
    for (NSString *var in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
        self.variablesUsed.text = [NSString stringWithFormat:@"%@ = %g  %@",  var, [[self.testVariableValues objectForKey:var] doubleValue], self.variablesUsed.text];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.enteringANumber = NO;
    self.enteredADecimalPoint = NO;
    [self updateLabels];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.enteringANumber) [self enterPressed];
    [self.brain pushOperation:sender.currentTitle];
    [self updateLabels];
}

- (IBAction)signPressed {
    if (self.enteringANumber) {
        double negated = [self.display.text doubleValue] * -1;
        self.display.text = [NSString stringWithFormat:@"%g", negated];
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.enteringANumber) [self enterPressed];
    [self.brain pushVariable:sender.currentTitle];
    [self updateLabels];
}

- (IBAction)testPressed:(UIButton *)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:0.0], @"x", 
            [NSNumber numberWithInt:-10000], @"y", 
            [NSNumber numberWithInt:42], @"z", nil];
    [self updateLabels];
}

- (IBAction)undoPressed {
    if (self.enteringANumber) {
        [self backspacePressed];
    } else {
        [self.brain undo];
        [self updateLabels];
    }
}

@end
