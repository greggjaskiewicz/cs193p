//
//  PsychologistViewController.m
//  Psychologist
//
//  Created by Jeremy Barth on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PsychologistViewController.h"
#import "HappinessViewController.h"

@interface PsychologistViewController()
@property (nonatomic) int diagnosis;
@end

@implementation PsychologistViewController

@synthesize diagnosis = _diagnosis;

- (HappinessViewController *)splitViewHappinessViewController {
    id hvc = [self.splitViewController.viewControllers lastObject];
    if (![hvc isKindOfClass:[HappinessViewController class]]) hvc = nil;
    return hvc;
}

- (void)setAndShowDiagnosis:(int)diagnosis {
    self.diagnosis = diagnosis;
    if ([self splitViewHappinessViewController]) {
        [self splitViewHappinessViewController].happiness = diagnosis;
    } else {
        [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDiagnosis"]) {
        [segue.destinationViewController setHappiness:self.diagnosis];
    } else if ([segue.identifier isEqualToString:@"Celebrity"]) {
        [segue.destinationViewController setHappiness:100];
    } else if ([segue.identifier isEqualToString:@"Serious"]) {
        [segue.destinationViewController setHappiness:20];
    } else if ([segue.identifier isEqualToString:@"TV Kook"]) {
        [segue.destinationViewController setHappiness:50];
    }
}

- (IBAction)flying {
    [self setAndShowDiagnosis:80];
}

- (IBAction)apple {
    [self setAndShowDiagnosis:100];
}

- (IBAction)dragons {
    [self setAndShowDiagnosis:20];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


@end
