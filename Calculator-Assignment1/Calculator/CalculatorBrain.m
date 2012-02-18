//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jeremy Barth on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end


@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack {
    if (!_operandStack) _operandStack = [NSMutableArray new];
    return _operandStack;
}

- (void)clear {
    [self.operandStack removeAllObjects];
}

- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *lastOperand = [self.operandStack lastObject];
    if (lastOperand) [self.operandStack removeLastObject];
    return [lastOperand doubleValue];
}

- (double)runOperation:(NSString *)operation {
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        result = [self popOperand] - [self popOperand];
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double n = [self popOperand];
        double d = [self popOperand];
        if (d != 0) {
            result = n / d;
        } else {
            result = 0;
        }
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    
    return result;
}
@end


