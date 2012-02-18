//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jeremy Barth on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

// assignment 1
- (void)pushOperand:(double)operand;
- (void)pushOperation:(NSString *)operation;
- (void)clear;

// assignment 2
@property (readonly) id program; // always a Property List

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
      usingVariables:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
- (void)pushVariable:(NSString *)variable;
+ (NSSet *)variablesUsedInProgram:(id)program;
- (void)undo;

@end
