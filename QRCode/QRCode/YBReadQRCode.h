//
//  YBReadQRCode.h
//  QRCode
//
//  Created by Queuey on 16/5/26.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YBReadQRCode : NSObject

+ (NSString *)contentWithQRCode:(UIImage *)codeImage;


@end
