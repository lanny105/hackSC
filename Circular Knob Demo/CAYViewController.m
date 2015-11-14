//
//  CAYViewController.m
//  Circular Knob Demo
//
//  Created by Scott Erholm on 1/30/14.
//  Copyright (c) 2014 Cayuse Concepts. All rights reserved.
//

#import "CAYViewController.h"

@interface CAYViewController ()

@property (strong, nonatomic) CAYSwirlGestureRecognizer *swirlGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *Currenttext;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSRunLoop *runner;
//@property (weak, nonatomic) IBOutlet UIView *clockTopView;
@end

@implementation CAYViewController

float bearing = 0.0;

float currentcount = 0.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateTimeDisplay];
    
	self.swirlGestureRecognizer = [[CAYSwirlGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
    
    [self.swirlGestureRecognizer setDelegate:self];
    
    [self.controlsView addGestureRecognizer:self.swirlGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetToZero:)];
    
    [self.tapGestureRecognizer setDelegate:self];
    
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
    
    [self.controlsView addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.swirlGestureRecognizer requireGestureRecognizerToFail:self.tapGestureRecognizer];
}

- (void)rotationAction:(id)sender {
    
    if([(CAYSwirlGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGFloat direction = ((CAYSwirlGestureRecognizer*)sender).currentAngle - ((CAYSwirlGestureRecognizer*)sender).previousAngle;
    
    bearing += 180 * direction / M_PI;
    
    if (direction>0) {
        currentcount += 1;
    } else {
        currentcount -=1;
    }
    
//    currentcount += direction;
    

    //let sceneView = self.view as! SCNView

    
    //spriteScene = OverlayScene(size: self.view.bounds.size)
    //spriteScene.timer()
    
    NSLog(@"THE LOG SCORE : %f", currentcount);
    
    

    
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: now];
    
    
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    
    
    
    
    NSDate *alarm = [newDate dateByAddingTimeInterval:60*currentcount];
    
    
    //  get current date
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    units |= NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *currentComponents = [gregorian components:units fromDate:alarm];
    alarm = [gregorian dateFromComponents:currentComponents];
    
    //  format and display the time
    NSString *currentTimeString = [NSDateFormatter localizedStringFromDate:alarm dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSLog(@"Current hour = %@", currentTimeString);
    self.position.text = currentTimeString;


    
    
    
    

    
//    else if(minute>=10){
//        result += "\(minute):"
//    }
//    
//    else{
//        result += "00:"
//    }
//    
//    if(self.timecount%60<10){
//        result += "0\(self.timecount%60)"
//    }
//    
//    else{
//        result += "\(self.timecount%60)"
//    }

    
    
    
    
//    if (bearing < -0.5) {
//        bearing += 360;
//    }
//    else if (bearing > 359.5) {
//        bearing -= 360;
//    }
    
    CGAffineTransform knobTransform = self.knob.transform;
    
    CGAffineTransform newKnobTransform = CGAffineTransformRotate(knobTransform, direction);

//    [self.knob setTransform:newKnobTransform];
    
//    NSLog(@"THE LOG SCORE : %f", bearing);
    
    //self.position.text = [NSString stringWithFormat:@"%dº", (int)lroundf(currentcount)];
}

- (void)resetToZero:(id)sender {
    [self animateRotationToBearing:0];
}


- (void)animateRotationToBearing:(int)direction {
    
    //bearing = direction;
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(180 * direction / M_PI);
    
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDelegate:self];
    [UIImageView setAnimationDuration:0.8f];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self.knob setTransform:rotationTransform];
    
    [UIImageView commitAnimations];
    
    self.position.text = [NSString stringWithFormat:@"%dº", direction];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)updateTimeDisplay {
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow: 0];
    self.timer = [[NSTimer alloc] initWithFireDate:now
                                          interval:1
                                            target:self
                                          selector:@selector(updateTime)
                                          userInfo:nil
                                           repeats:YES];
    self.runner = [NSRunLoop currentRunLoop];
    [self.runner addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)updateTime {
    //  use gregorian calendar for calendrical calculations
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //  get current date
    NSDate *date = [NSDate date];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    units |= NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *currentComponents = [gregorian components:units fromDate:date];
    date = [gregorian dateFromComponents:currentComponents];
    
    //  format and display the time
    NSString *currentTimeString = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    NSLog(@"Current hour = %@", currentTimeString);
    self.Currenttext.text = currentTimeString;
    
}



@end
