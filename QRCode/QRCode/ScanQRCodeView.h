//
//  ScanQRCode.h
//  QRCode
//
//  Created by Queuey on 16/5/25.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ScanQRCodeDelegate <NSObject>

- (void)outputQRCodeMessage:(NSString *)message;

@end


@interface ScanQRCodeView : UIView

@property (nonatomic, weak)id<ScanQRCodeDelegate> delegate;

/**扫描窗口Frame，默认为2/3 self.width 居中显示*/
@property (nonatomic, assign)CGRect scanViewFrame;

/**
 *	开始扫描
 */
- (void)startScan;
/**
 *	结束扫描
 */
- (void)stopScan;

@end
