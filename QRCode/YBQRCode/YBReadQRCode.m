//
//  YBReadQRCode.m
//  QRCode
//
//  Created by Queuey on 16/5/26.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "YBReadQRCode.h"

@implementation YBReadQRCode


+ (NSString *)contentWithQRCode:(UIImage *)codeImage {
	CIContext  *context  = [CIContext contextWithOptions:nil];
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
	CIImage *image = [CIImage imageWithCGImage:codeImage.CGImage];
	NSArray *features = [detector featuresInImage:image];
	CIQRCodeFeature *feature = [features firstObject];
	
	NSString *result = feature.messageString;
	return result;
}


@end
