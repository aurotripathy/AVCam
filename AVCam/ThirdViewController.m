//
//  ThirdViewController.m
//  AVCam Objective-C
//
//  Created by Auro Tripathy on 10/30/16.
//  Copyright © 2016 ShatterlIne Labs. All rights reserved.
//

#import "ThirdViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ThirdViewController ()

@end

@implementation ThirdViewController


// taken from http://supereasyapps.com/blog/2014/8/4/create-a-uibutton-in-code-with-objective-c

- (void)video {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
    
    
    [self presentModalViewController:imagePicker animated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [videoUrl path];
        NSLog(@"The video file path, @%@", moviePath);
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        }
    }
    
    
    [[ALAssetsLibrary new] assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
        UIImage *thumb = [UIImage imageWithCGImage:asset.thumbnail];
        NSLog(@"Thumb size %f, %f", thumb.size.height, thumb.size.width);
        UIImageView * myImageView = [[UIImageView alloc] initWithImage: thumb];
        
        UIImageView *thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25,200,125,125)]; //just example change the frame as per your need
        thumbImgView.image = thumb;
        [self.view addSubview:thumbImgView];
        
    } failureBlock:^(NSError *error) {
        // handle error
    }];
    
    [self dismissModalViewControllerAnimated:YES];
    // auro [picker release];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Pick Video" forState:UIControlStateNormal];
    [button sizeToFit];
    
    // Set a new (x,y) point for the button's center
    button.center = CGPointMake(320/2, 60);
    
    [button addTarget:self
               action:@selector(video)
     forControlEvents:UIControlEventTouchUpInside];
     
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end