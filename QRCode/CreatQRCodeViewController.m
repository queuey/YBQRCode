//
//  CreatQRCodeViewController.m
//  QRCode
//
//  Created by Queuey on 16/5/24.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "CreatQRCodeViewController.h"
#import "YBCreatQRCode.h"

@interface CreatQRCodeViewController ()

@property (nonatomic, strong) UIImageView *showQRCode;

@end

@implementation CreatQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"生成二维码";
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self.view addSubview:self.showQRCode];
	
	NSString *content = @"成功了";

	UIImage *icon = [UIImage imageNamed:@"abc.jpg"];
	
	self.showQRCode.image = [YBCreatQRCode QRCode:content tintColor:[UIColor redColor] icon:icon scale:0.3];
}


- (UIImageView *)showQRCode {
	if (!_showQRCode) {
		_showQRCode = ({
			UIImageView *imageView = UIImageView.new;
			imageView.frame = CGRectMake(100, 100, 200, 200);
			imageView;
		});
	}
	return _showQRCode;
}

@end

