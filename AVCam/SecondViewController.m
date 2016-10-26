//
//  SecondViewController.m
//  AVCam Objective-C
//
//  Created by Auro Tripathy on 10/25/16.
//  Copyright © 2016 ShatterlIne Labs. All rights reserved.
//

#import "SecondViewController.h"
#import "common.h"

@interface SecondViewController ()

@end
//GLOBALS
NSMutableURLRequest *postRequest;
NSString *recipientPhoneNumber;

@implementation SecondViewController

// https://code.tutsplus.com/tutorials/ios-sdk-uitextfield-uitextfielddelegate--mobile-10943

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect phoneTextFieldFrame = CGRectMake(20.0f, 100.0f, 280.0f, 31.0f);
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame:phoneTextFieldFrame];
    phoneTextField.placeholder = @"14088025434";
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.textColor = [UIColor blackColor];
    phoneTextField.font = [UIFont systemFontOfSize:17.0f];
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.returnKeyType = UIReturnKeyDone;
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.tag = 2;
    phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    phoneTextField.delegate = self;
    [self.view addSubview:phoneTextField];
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


// This method is called once we complete editing
// It also fires off the ReST API
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
    NSLog(@"the text is %@", textField.text);
    recipientPhoneNumber = textField.text;
    [self setPostPhoneParams:recipientPhoneNumber];
    NSLog(@"Invoking the ReST API %@", RECEIVER_PHONE_URL);
    
    NSError *http_error = nil;
    NSURLResponse *responseStr = nil;
    NSData *syncResData;
    syncResData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&responseStr error:&http_error];
    NSString *returnString = [[NSString alloc] initWithData:syncResData encoding:NSUTF8StringEncoding];
    
    NSLog(@"ERROR %@", http_error);
    NSLog(@"RES %@", responseStr);
    
    NSLog(@"RETURN STRING:%@", returnString);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL) setPostPhoneParams:(NSString *)phone{
    
    if(recipientPhoneNumber != nil) {
        postRequest = [NSMutableURLRequest new];
        postRequest.timeoutInterval = 20.0;
        [postRequest setURL:[NSURL URLWithString:UPLOAD_URL]];
        [postRequest setHTTPMethod:@"POST"];
        
        NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        recipientPhoneNumber, @"phone",
                                        nil];
        NSError *error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                            options:NSJSONWritingPrettyPrinted error:&error];
        [postRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [postRequest setHTTPBody:jsonData];
        
        return TRUE;
        
    }else{
        return FALSE;
    }
}


@end
