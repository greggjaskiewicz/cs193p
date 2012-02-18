//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jeremy Barth on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)runOperation:(NSString *)operation;
- (void)clear;

@end
