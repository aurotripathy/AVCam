//
//  SecondViewController.m
//  AVCam Objective-C
//
//  Created by Auro Tripathy on 10/25/16.
//  Copyright © 2016 ShatterlIne Labs. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
    NSLog(@"the text is %@", textField.text);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
