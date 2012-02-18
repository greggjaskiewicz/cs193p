//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jeremy Barth on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;

@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (!_programStack) _programStack = [NSMutableArray new];
    return _programStack;
}

- (void)clear {
    [self.programStack removeAllObjects];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (void)pushOperation:(NSString *)operation {
    [self.programStack addObject:operation];
}

- (id)program {
    return [self.programStack copy];
}

+ (NSMutableArray *)castProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return stack;
}

+ (BOOL)isTwoOperandOperation:(NSString *)operation {
    NSSet *operations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isOneOperandOperation:(NSString *)operation {
    NSSet *operations = [[NSSet alloc] initWithObjects:@"sin", @"cos", @"sqrt", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isNoOperandOperation:(NSString *)operation {
    NSSet *operations = [[NSSet alloc] initWithObjects:@"π", nil];
    return [operations containsObject:operation];
}

+ (BOOL)isOperation:(NSString *)operation {
    NSSet *operations = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos", @"sqrt", @"π", nil];
    return [operations containsObject:operation];
}

+ (NSString *)printStack:(NSMutableArray *)stack {
    NSString *result;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat:@"%g", [topOfStack doubleValue]];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        if ([self isOperation:topOfStack]) {
            NSString *operation = topOfStack;
            if ([self isNoOperandOperation:operation]) {
                result = operation;
            } else {
                NSString *operand = [self printStack:stack];
                if ([self isTwoOperandOperation:operation]) {
                    result = [NSString stringWithFormat:@"(%@ %@ %@)", [self printStack:stack], operation, operand];
                } else if ([self isOneOperandOperation:operation]) {
                    result = [NSString stringWithFormat:@"%@(%@)", operation, operand];            
                }
            }
        } else {
            result = topOfStack; // variable
        }
    }
    
    return result;    
}

+ (NSString *)descriptionOfProgram:(id)program {
    return [self printStack:[self castProgram:program]];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
         usingVariableValues:(NSDictionary *)variableValues {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] + [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double temp = [self popOperandOffStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] - temp;
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack usingVariableValues:variableValues] * [self popOperandOffStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"/"]) {
            double d = [self popOperandOffStack:stack usingVariableValues:variableValues];
            double n = [self popOperandOffStack:stack usingVariableValues:variableValues];
            if (d != 0) {
                result = n / d;
            } else {
                result = 0;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack usingVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else {
            result = [[variableValues valueForKey:operation] doubleValue];
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program 
      usingVariables:(NSDictionary *)variableValues {
    return [self popOperandOffStack:[self castProgram:program] usingVariableValues:variableValues];
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariables:[NSDictionary new]];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableArray *stack = [self castProgram:program];
    NSMutableSet *variables = [NSMutableSet new];
    for (id i in stack) {
        if ([i isKindOfClass:[NSString class]] && ![self isOperation:i]) {
            [variables addObject:i];
        }
    }
    if (variables.count > 0) {
        return [variables copy];
    } else {
        return nil;
    }
}

- (void)undo {
    [self.programStack removeLastObject];
}

@end


