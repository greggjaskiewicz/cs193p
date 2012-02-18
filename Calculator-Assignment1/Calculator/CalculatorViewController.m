//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jeremy Barth on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

@property (nonatomic) BOOL enteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL enteredADecimalPoint;

@end


@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize enteringANumber = _enteringANumber;
@synthesize brain = _brain;
@synthesize enteredADecimalPoint = _enteredADecimalPoint;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [CalculatorBrain new];
    return _brain;
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.history.text = @"";
    self.enteringANumber = NO;
    self.enteredADecimalPoint = NO;
    [self.brain clear];
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

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.enteringANumber = NO;
    self.enteredADecimalPoint = NO;
    self.history.text = [self.history.text stringByAppendingString:self.display.text];
    self.history.text = [self.history.text stringByAppendingString:@" "];
    self.display.text = @"0";
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.enteringANumber) [self enterPressed];
    self.display.text = [NSString stringWithFormat:@"%g", [self.brain runOperation:sender.currentTitle]];
    self.history.text = [self.history.text stringByAppendingString:sender.currentTitle];
    self.history.text = [self.history.text stringByAppendingString:@" = "];
}

- (IBAction)signPressed {
    if (self.enteringANumber) {
        double negated = [self.display.text doubleValue] * -1;
        self.display.text = [NSString stringWithFormat:@"%g", negated];
    }
}

@end
