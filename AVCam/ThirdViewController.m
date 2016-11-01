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
#import "common.h"


@interface ThirdViewController ()

@end

@implementation ThirdViewController


// taken from http://supereasyapps.com/blog/2014/8/4/create-a-uibutton-in-code-with-objective-c

// GLOBALS
NSString *uploadFilePath;
NSMutableURLRequest *vidRequest;
NSData *videoData;

-(BOOL) setPostVideoParams:(NSData *)videoData{
    
    if(videoData != nil) {
        vidRequest = [NSMutableURLRequest new];
        vidRequest.timeoutInterval = 20.0;
        [vidRequest setURL:[NSURL URLWithString:VIDEO_UPLOAD_URL]];
        [vidRequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [vidRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        
        [vidRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [vidRequest setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.mov\"\r\n", @"Uploaded_vid"]   dataUsingEncoding:NSUTF8StringEncoding]];
        
        //auro
        // TODO should the mime type be image/jpeg
        // [body appendData:[@"Content-Type: image/jpeg" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:videoData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [vidRequest setHTTPBody:body];
        [vidRequest addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        NSLog(@"HTTP Content Length = %lu", (unsigned long)body.length);
        
        return TRUE;
        
    }else{
        return FALSE;
    }
}



- (void)sendVideo {
    
    NSLog(@"Here's where we send video and the file path is, %@", uploadFilePath); // may not be needed
    [self setPostVideoParams:videoData];    NSError *http_error = nil;
    NSURLResponse *responseStr = nil;
    NSData *syncResData;
    syncResData = [NSURLConnection sendSynchronousRequest:vidRequest returningResponse:&responseStr error:&http_error];
    NSString *returnString = [[NSString alloc] initWithData:syncResData encoding:NSUTF8StringEncoding];
    
    NSLog(@"ERROR %@", http_error);
    NSLog(@"RES %@", responseStr);
    
    NSLog(@"RETURN STRING:%@", returnString);
    
    
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
        videoData = [[NSData alloc] initWithContentsOfURL:videoUrl];
        
        NSString *moviePath = [videoUrl path];
        NSLog(@"The video file path, @%@", moviePath);
        uploadFilePath = [moviePath mutableCopy]; // not needed auro
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil); //Auro why are we doing this??
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
