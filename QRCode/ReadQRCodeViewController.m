//
//  ReadQRCodeViewController.m
//  QRCode
//
//  Created by Queuey on 16/5/26.
//  Copyright © 2016年 Mr.Q. All rights reserved.
//

#import "ReadQRCodeViewController.h"
#import "YBReadQRCode.h"

@interface ReadQRCodeViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong)UIImageView *codeView;

@end

@implementation ReadQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"读取二维码";
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self.view addSubview:self.codeView];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(selectImage)];
}

#pragma mark - event respond

- (void)readImage:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		NSString * info = [YBReadQRCode contentWithQRCode:self.codeView.image];
		NSLog(@"%@",info);
		[self showAlert:info];
	}
}

- (void)selectImage {
	UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		//pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
	}
	pickerImage.delegate = self;
	pickerImage.allowsEditing = NO;
	[self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)showAlert:(NSString *)alert {
	[[[UIAlertView alloc] initWithTitle:alert message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	//选择的类型必须是图片
	if ([type isEqualToString:@"public.image"]) {
		UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		NSString * infos = [YBReadQRCode contentWithQRCode:image];
		[self showAlert:infos];
	}
	[picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - setter && getter

- (UIImageView *)codeView {
	if (!_codeView) {
		_codeView = ({
			UIImageView *imageView = [[UIImageView alloc] init];
			imageView.frame = CGRectMake(100, 100, 200, 200);
			imageView.image = [UIImage imageNamed:@"1464242118"];
			[imageView setUserInteractionEnabled:YES];
			UILongPressGestureRecognizer * longPress;
			longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readImage:)];
			[imageView addGestureRecognizer:longPress];
			imageView;
		});
	}
	return _codeView;
}


@end
