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


- (void)sendVideo {
    
    NSLog(@"Here's where we send video");
}

- (void)pickVideo {
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
        
        UIImageView *thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,125,125)];
        //UIImageView *thumbImgView = [[UIImageView alloc] init];
        thumbImgView.image = thumb;
        thumbImgView.center = self.view.center;
        //thumbImgView.contentMode = UIViewContentModeCenter;
        
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
    
    UIButton *pickVidButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [pickVidButton setTitle:@"Pick Video" forState:UIControlStateNormal];
    [pickVidButton sizeToFit];
    
    // Set a new (x,y) point for the button's center
    pickVidButton.center = CGPointMake(320/2, 100);
    
    [pickVidButton addTarget:self
               action:@selector(pickVideo)
     forControlEvents:UIControlEventTouchUpInside];
     
    [self.view addSubview:pickVidButton];
    
    
    UIButton *loadVidButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadVidButton setTitle:@"Send Video" forState:UIControlStateNormal];
    [loadVidButton sizeToFit];
    
    // Set a new (x,y) point for the button's center
    loadVidButton.center = CGPointMake(320/2, 400);
    
    [loadVidButton addTarget:self
                      action:@selector(sendVideo)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loadVidButton];
    
    
    
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
