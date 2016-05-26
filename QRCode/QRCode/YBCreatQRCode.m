//
//  YBQRCode.m
//  QRCode
//
//  Created by Queuey on 16/5/24.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "YBCreatQRCode.h"

const CGFloat scale_extent = 500.0;

@implementation YBCreatQRCode


void ProviderReleaseData (void *info, const void *data, size_t size) {
	free((void*)data);
}

/**
 *	快速生成一个二维码
 *
 *	@param content	二维码内容
 *
 *	@return 返回一个标准二维码
 */
+ (UIImage *)QRCode:(NSString *)content {
	return [[self class] QRCode:content correction:kCorrectionLevelTypeHigh];
}

/**
 *	快速生成一个二维码
 *
 *	@param content	二维码内容
 *	@param type  	二维码质量
 *
 *	@return 返回一个纠错质量的二维码
 */
+ (UIImage *)QRCode:(NSString *)content correction:(CorrectionLevelType)type {
	CIImage *ciImage = [[self class] CIImageWithQRCode:content correction:type];
	return [[self class] imageWithQRCode:ciImage correction:kCorrectionLevelTypeHigh];
}


/**
 *	快速生成一个二维码
 *
 *	@param content	二维码内容
 *	@param color	二维码颜色
 *
 *	@return 返回一个标准二维码
 */
+ (UIImage *)QRCode:(NSString *)content tintColor:(UIColor *)color {
	UIImage *image = [[self class] QRCode:content];
	return [[self class] imageWithRawQRCode:image imageColor:color];
}


/**
 *	生成一个带ICON图标的二维码
 *
 *	@param content	二维码信息
 *	@param icon		ICON
 *	@param scale	icon占二维码比例大小 0.0 ~ 1.0
 *
 *	@return 返回一个带icon的二维码
 */
+ (UIImage *)QRCode:(NSString *)content icon:(UIImage *)icon scale:(CGFloat)scale {
	UIImage *image = [[self class] QRCode:content correction:kCorrectionLevelTypeHigh];
	return [[self class] imageWithRawQRCode:image icon:icon scale:scale];
}

/**
 *	生成一个带ICON图标的彩色二维码
 *
 *	@param content	二维码信息
 *	@param color	二维码颜色
 *	@param icon		ICON
 *	@param scale	icon占二维码比例大小 0.0 ~ 1.0
 *
 *	@return 返回一个带icon的二维码
 */
+ (UIImage *)QRCode:(NSString *)content
		  tintColor:(UIColor *)color
			   icon:(UIImage *)icon
			  scale:(CGFloat)scale {
	UIImage *image = [[self class] QRCode:content tintColor:color];
	return [[self class] imageWithRawQRCode:image icon:icon scale:scale];
}


/**
 *	通过CIFilter生成CIImage
 *
 *	@param content	二维码内容
 *	@param level	二维码质量
 *
 *	@return 返回CIImage对象
 */
+ (CIImage *)CIImageWithQRCode:(NSString *)content correction:(CorrectionLevelType)level {
	
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	
	NSString * const inputCorrectionLevel = @"inputCorrectionLevel";
	NSString * inputCorrectionLevelValue;
	
	switch (level) {
		case kCorrectionLevelTypeLow: {
			inputCorrectionLevelValue = @"L";
		} break;
		case kCorrectionLevelTypeMedium: {
			inputCorrectionLevelValue = @"M";
		} break;
		case kCorrectionLevelTypeHigh: {
			inputCorrectionLevelValue = @"Q";
		} break;
		default: {
			inputCorrectionLevelValue = @"Q";
		} break;
	}
	[filter setValue:inputCorrectionLevelValue forKey:inputCorrectionLevel];
	NSData *contentdata = [content dataUsingEncoding:NSUTF8StringEncoding];
	[filter setValue:contentdata forKey:@"inputMessage"];
	
	return filter.outputImage;
}

/**
 *	生成一个指定纠错等级的二维码图片
 *
 *	@param content	二维码原始图片
 *	@param level	纠正等级
 *
 *	@return 返回一个高像素的二维码
 */
+ (UIImage *)imageWithQRCode:(CIImage *)ciImage correction:(CorrectionLevelType)level {
	//获取要输出的Image长宽
	CGRect extent = CGRectIntegral(ciImage.extent);
	CGFloat size  = scale_extent;
	CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
	size_t width  = CGRectGetWidth(extent) * scale;
	size_t height = CGRectGetHeight(extent) * scale;
	
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
	
	CGContextRef contextRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
	CIContext * context = [CIContext contextWithOptions:nil];
	CGImageRef imageRef = [context createCGImage:ciImage fromRect:extent];
	CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
	CGContextScaleCTM(contextRef, scale, scale);
	CGContextDrawImage(contextRef, extent, imageRef);
	
	CGImageRef imageRefResized = CGBitmapContextCreateImage(contextRef);
	
	//Release
	CGContextRelease(contextRef);
	CGImageRelease(imageRef);
	
	return [UIImage imageWithCGImage:imageRefResized];
}

/**
 *	给原二维码上加Icon
 *
 *	@param rawQRCode	原二维码图像
 *	@param icon			需要加的icon
 *	@param scale		icon占二维码的比例  0.0 ~ 1.0
 *
 *	@return 返回一个带icon的二维码
 */
+ (UIImage *)imageWithRawQRCode:(UIImage *)rawQRCode icon:(UIImage *)icon scale:(CGFloat)scale {
	UIImage *image = rawQRCode;
	UIGraphicsBeginImageContext(image.size);
	
	CGFloat imageWidth  = image.size.width;
	CGFloat imageHeight = image.size.height;
	CGFloat iconWidth   = imageWidth *scale;
	CGFloat iconHeight  = imageHeight *scale;
	
	[image drawInRect:CGRectMake(0.0, 0.0, imageWidth, imageHeight)];
	[icon drawInRect:CGRectMake((imageWidth - iconWidth)/2.0,
								(imageHeight - iconHeight)/2.0,
								iconWidth,
								iconHeight)];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return img;
}

/**
 *	生成一个带颜色的二维码
 *
 *	@param rawImage	待处理二维码图
 *	@param color	二维码颜色
 *
 *	@return 返回一个带相应的二维码
 */
+ (UIImage *)imageWithRawQRCode:(UIImage *)rawImage imageColor:(UIColor *)color {
	UIImage *image = rawImage;
	const CGFloat imageWidth = image.size.width;
	const CGFloat imageHeight = image.size.height;
	size_t bytesPerRow = imageWidth * 4;
	uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
	
	//Create context
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGContextRef contextRef = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
	
	//改变数组保存的颜色信息
	[[self class] rgbImageBuf:rgbImageBuf pixe:imageWidth *imageHeight currentColor:color];
	
	//Convert to image
	CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
	CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
										kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProviderRef,
										NULL, true, kCGRenderingIntentDefault);
	CGDataProviderRelease(dataProviderRef);
	UIImage* img = [UIImage imageWithCGImage:imageRef];
	
	//Release
	CGImageRelease(imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpaceRef);
	return img;
}



+ (void)rgbImageBuf:(uint32_t *)imageBuf pixe:(NSInteger)pixe currentColor:(UIColor *)color {
	//默认为黑色
	CGFloat R = 0.0, G = 0.0, B = 0.0;
	CGColorRef colorRef = [color CGColor];
	size_t numComponents = CGColorGetNumberOfComponents(colorRef);
	//color改成RGB色值
	if (numComponents == 4) {
		const CGFloat *components = CGColorGetComponents(colorRef);
		R = components[0] * 255;
		G = components[1] * 255;
		B = components[2] * 255;
	}
	uint32_t* pCurPtr = imageBuf;
	for (int i = 0; i < pixe; i++, pCurPtr++) {
		if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
			//Change color 需要填充的为16进制
			uint8_t* ptr = (uint8_t*)pCurPtr;
			ptr[3] = R;
			ptr[2] = G;
			ptr[1] = B;
		} else {
			uint8_t *ptr = (uint8_t *) pCurPtr;
			ptr[0] = 0;
		}
	}
}



@end