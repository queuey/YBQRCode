//
//  ScanQRCode.m
//  QRCode
//
//  Created by Queuey on 16/5/25.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "ScanQRCodeView.h"
#import <AVFoundation/AVFoundation.h>


CGFloat const kScanViewsCaling = 4 / 6;


@interface ScanQRCodeView ()
<
AVCaptureMetadataOutputObjectsDelegate
>

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (strong, nonatomic) CAShapeLayer               *maskLayer;


@end



@implementation ScanQRCodeView

- (instancetype)init {
	self = [super init];
	if (self) {
		[self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
		[self.session addInput:self.input];
		[self.session addOutput:self.output];
		self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
		
		[self.layer insertSublayer:self.preview atIndex:0];
	}
	return self;
}

- (void)layoutSubviews {
	CGRect scanRect = self.scanViewFrame;
	CGSize windowSize = [UIScreen mainScreen].bounds.size;
	scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
	self.output.rectOfInterest = scanRect;
	
	[self.layer addSublayer:self.maskLayer];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
	if (metadataObjects.count) {
		[self.session stopRunning];
		//输出扫描字符串
		AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
		[self.delegate outputQRCodeMessage:metadataObject.stringValue];
	}
}

- (void)startScan {
	[self.session startRunning];
}

- (void)stopScan {
	[self.session stopRunning];
}


#pragma mark - getters and setters

- (AVCaptureDevice *)device {
	if (!_device) {
		_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	}
	return _device;
}

- (AVCaptureDeviceInput *)input {
	if (!_input) {
		_input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
	}
	return _input;
}

- (AVCaptureMetadataOutput *)output {
	if (!_output) {
		_output = [[AVCaptureMetadataOutput alloc] init];
	}
	return _output;
}

- (AVCaptureSession *)session {
	if (!_session) {
		_session = [[AVCaptureSession alloc] init];
		[_session setSessionPreset:([UIScreen mainScreen].bounds.size.height < 500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
	}
	return _session;
}

- (AVCaptureVideoPreviewLayer *)preview {
	if (!_preview) {
		_preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
		_preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
		_preview.frame = [UIScreen mainScreen].bounds;
	}
	return _preview;
}

- (CAShapeLayer *)maskLayer {
	if (!_maskLayer) {
		_maskLayer = ({
			CAShapeLayer * maskLayer = [CAShapeLayer layer];
			UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
			[path appendPath:[[UIBezierPath bezierPathWithRect: self.scanViewFrame]bezierPathByReversingPath]];
			maskLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
			maskLayer.path = path.CGPath;
			maskLayer;
		});
	}
	return _maskLayer;
}

- (CGRect)scanViewFrame {
	if (!_scanViewFrame.size.height) {
		CGSize windowSize = [UIScreen mainScreen].bounds.size;
		CGSize scanSize = CGSizeMake(windowSize.width* kScanViewsCaling, windowSize.width*kScanViewsCaling);
		CGRect scanRect = CGRectMake((windowSize.width - scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
		_scanViewFrame = scanRect;
	}
	return _scanViewFrame;
}

@end
