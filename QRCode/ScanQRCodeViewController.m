//
//  ScanQRCodeViewController.m
//  QRCode
//
//  Created by Queuey on 16/5/24.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "ScanQRCodeViewController.h"

#import "ScanQRCodeView.h"

@interface ScanQRCodeViewController ()
<
ScanQRCodeDelegate,
UIAlertViewDelegate
>

@property(nonatomic, strong)ScanQRCodeView * codeView;

@end

@implementation ScanQRCodeViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"扫描二维码";
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self.view addSubview:self.codeView];
	[self.codeView startScan];
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self.codeView startScan];
}

- (void)outputQRCodeMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
	
	[alert show];

}


- (ScanQRCodeView *)codeView {
	if (!_codeView) {
		_codeView = ({
			ScanQRCodeView *code = [[ScanQRCodeView alloc] init];
			code.delegate = self;
			code.frame = self.view.frame;
			//code.scanViewFrame = CGRectMake(100, 100, 150, 150);
			code;
		});
	}
	return _codeView;
}

@end



