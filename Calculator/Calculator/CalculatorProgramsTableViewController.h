//
//  CalculatorProgramsTableViewController.h
//  Calculator
//
//  Created by Jeremy Barth on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramsTableViewController;

@protocol CalculatorProgramsTableViewControllerDelegate
@optional
- (void)CalculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender 
                                 choseProgram:(id)program;
@end

@interface CalculatorProgramsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *programs;  // CalculatorBrain Programs
@property (nonatomic, weak) id <CalculatorProgramsTableViewControllerDelegate> delegate;
@end
