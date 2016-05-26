//
//  ViewController.m
//  QRCode
//
//  Created by Queuey on 16/5/24.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRCodeViewController.h"
#import "CreatQRCodeViewController.h"
#import "ReadQRCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (IBAction)scanQRCode:(id)sender {
	[self.navigationController pushViewController:ScanQRCodeViewController.new animated:YES];
}

- (IBAction)creatQRCode:(id)sender {
	[self.navigationController pushViewController:CreatQRCodeViewController.new animated:YES];
}

- (IBAction)readQRCode:(id)sender {
	[self.navigationController pushViewController:ReadQRCodeViewController.new animated:YES];
}


@end
