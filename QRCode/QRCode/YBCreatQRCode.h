//
//  YBQRCode.h
//  QRCode
//
//  Created by Queuey on 16/5/24.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CorrectionLevelType) {
	kCorrectionLevelTypeLow,
	kCorrectionLevelTypeMedium,
	kCorrectionLevelTypeHigh
};


@interface YBCreatQRCode : NSObject

/**
 *	快速生成一个二维码
 *
 *	@param content	二维码内容
 *
 *	@return 返回一个标准二维码
 */
+ (UIImage *)QRCode:(NSString *)content;

/**
 *	快速生成一个纠错纠错质量可控的二维码
 *
 *	@param content	二维码内容
 *	@param type  	二维码质量
 *
 *	@return 返回一个纠错质量的二维码
 */
+ (UIImage *)QRCode:(NSString *)content correction:(CorrectionLevelType)type;

/**
 *	快速生成一个彩色二维码
 *
 *	@param content	二维码内容
 *	@param color	二维码颜色
 *
 *	@return 返回一个彩色二维码
 */

+ (UIImage *)QRCode:(NSString *)content tintColor:(UIColor *)color;


/**
 *	生成一个带ICON图标的二维码
 *
 *	@param content	二维码信息
 *	@param icon		ICON
 *	@param scale	icon占二维码比例大小 0.0 ~ 1.0
 *
 *	@return 返回一个带icon的二维码
 */

+ (UIImage *)QRCode:(NSString *)content icon:(UIImage *)icon scale:(CGFloat)scale;

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
			  scale:(CGFloat)scale;


@end

