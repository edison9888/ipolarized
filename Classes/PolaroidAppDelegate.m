/*
 * iPolarize - a Polaroid App for iPhone
 * Copyright (C) 2009. Kesava Abhinav Yerra <abhi@traytwo.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


#import "PolaroidAppDelegate.h"

@implementation PolaroidAppDelegate


@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.window = [[[UIWindow alloc]
					initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	mainViewController = [[UIImagePickerController alloc] init];
	mainViewController.delegate = self;
	mainViewController.sourceType = UIImagePickerControllerSourceTypeCamera;

	[window addSubview:mainViewController.view];
	
	imageView = [[UIImageView alloc] initWithFrame:[window bounds]];
	imageView.hidden = YES;
	
	[window addSubview:imageView];
    [window makeKeyAndVisible];
}


- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo {
	
	[picker dismissModalViewControllerAnimated:YES];
	mainViewController.view.hidden = YES;

	UIImage *background = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background" ofType:@"jpg" inDirectory:@""]];	
	UIImage *mask = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mask" ofType:@"png" inDirectory:@""]];	

	UIImage *polarizedImage;
	
	CGContextRef context;
	CGRect r = CGRectMake(0, 0, image.size.width, image.size.height);	

//	image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], r)];

	UIGraphicsBeginImageContext(image.size);
	context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, r);
	
	//CGContextClipToMask(context, r, mask.CGImage);

	[image drawInRect:r];

	//[image drawInRect:r blendMode:kCGBlendModeNormal alpha:0.5];
	[background drawInRect:r blendMode:kCGBlendModeSoftLight alpha:0.9];
	[background drawInRect:r blendMode:kCGBlendModePlusDarker alpha:0.3];
	[background drawInRect:r blendMode:kCGBlendModeOverlay alpha:0.7];
//	[background drawInRect:r blendMode:kCGBlendModeLuminosity alpha:0.2];

	[mask drawInRect:r blendMode:kCGBlendModeNormal alpha:1.0];
	
	polarizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext(); 
	 
	imageView.image = polarizedImage;
	imageView.hidden = NO;
	
	[window bringSubviewToFront:imageView];

	UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
	exit(0);
}

- (void)dealloc {
    [mainViewController release];
    [window release];
	[imageView release];
    [super dealloc];
}

@end
