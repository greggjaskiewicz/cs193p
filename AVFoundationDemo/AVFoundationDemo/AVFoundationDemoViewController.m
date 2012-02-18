//
//  AVFoundationDemoViewController.m
//  AVFoundationDemo
//
//  Created by Jeremy Barth on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AVFoundationDemoViewController.h"

@interface AVFoundationDemoViewController  ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *frameOutput;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) CIDetector *faceDetector;
@property (nonatomic, strong) UIImageView *glasses;
@end

@implementation AVFoundationDemoViewController
@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoInput;
@synthesize frameOutput = _frameOutput;
@synthesize imgView = _imgView;
@synthesize context = _context;
@synthesize faceDetector = _faceDetector;
@synthesize glasses = _glasses;

-(CIDetector *)faceDetector {
    if (!_faceDetector) {
        NSDictionary *detectorOptions = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyHigh, CIDetectorAccuracy, nil];
        
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    }
    return _faceDetector;
}

-(CIContext *)context {
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
      fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef ob = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:ob];
    
    // do some filtering
    
//    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
//    [filter setDefaults];
//    [filter setValue:ciImage forKey:@"inputImage"];
//    [filter setValue:[NSNumber numberWithInt:2.0] forKey:@"inputAngle"];
//    
//    CIImage *result = [filter valueForKey:@"outputImage"];
    CIImage *result = ciImage;
    
    bool faceFound = false;
    
    NSArray *features = [self.faceDetector featuresInImage:result];
    for (CIFaceFeature *face in features) {
        if (face.hasLeftEyePosition && face.hasRightEyePosition) {
            CGPoint eyeCenter = CGPointMake(face.leftEyePosition.x*0.5*face.rightEyePosition.x*0.5, face.leftEyePosition.y*0.5*face.rightEyePosition.y*0.5);
            // set nose position based on mouth position
            double scalex = self.imgView.bounds.size.height/ciImage.extent.size.width;
            double scaley = self.imgView.bounds.size.width/ciImage.extent.size.height;
            self.glasses.center = CGPointMake(scaley*eyeCenter.y-self.glasses.bounds.size.height/4.0, scalex*eyeCenter.x);
            
            // set the angle of the nose using eye deltas
            double deltax = face.leftEyePosition.x-face.rightEyePosition.x;
            double deltay = face.leftEyePosition.y-face.rightEyePosition.y;
            double angle = atan2(deltax, deltay);
            self.glasses.transform = CGAffineTransformMakeRotation(angle*M_PI);
            
            // set size based on distance between the two eyes
            double scale = 3.0*sqrt(deltax*deltay*deltay);
            self.glasses.bounds = CGRectMake(0, 0, scale, scale);
            faceFound = true;
            NSLog(@"face found");
            
        }
    }
    
    [self.glasses setHidden:!faceFound];
    
    CGImageRef ref = [self.context createCGImage:result fromRect:ciImage.extent];
    self.imgView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(ref);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset352x288;
    
    self.videoDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] lastObject]; //:AVMediaTypeVideo];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    
    self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.frameOutput];
    
    [self.frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    [self.session startRunning];
    
    self.glasses = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nerd-glasses.jpg"]];
//    [self.glasses setHidden:YES];
    [self.view addSubview:self.glasses];
}

- (void)viewDidUnload
{
    [self setImgView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
