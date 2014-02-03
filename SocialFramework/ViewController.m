//
//  ViewController.m
//  SocialFramework
//
//  Created by Sunayna Jain on 2/3/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIImage *image;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.captionTextfield.delegate = self;
    self.sharedImageView.userInteractionEnabled = YES;
    self.sharedImageView.backgroundColor = [UIColor redColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupView];
}

-(void)setupView{

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takeImage:)];
    recognizer.numberOfTapsRequired = 1;
    [self.sharedImageView addGestureRecognizer:recognizer];
    
    NSLog(@"setup view called");

    [self updateView];
}

-(void)updateView{
    
    NSLog(@"update view called");
    
    if (self.image){
        self.shareButton.enabled = YES;
        self.facebookButton.enabled = YES;
    } else {
        self.facebookButton.enabled = NO;
        self.shareButton.enabled = NO;
        self.facebookButton.alpha = 0.5;
        self.shareButton.alpha = 0.5;
    }
}

-(void)takeImage:(id)sender{
    
    NSLog(@"take image method called");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    [imagePicker setDelegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originalImage) {
        self.image = originalImage;
        // Update View
        [self updateView];
    }
    // Dismiss Image Picker Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        // Update Image View
        self.sharedImageView.image = _image;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Resign First Responder
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookButtonPressed:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // Configure Compose View Controller
        [vc setInitialText:self.captionTextfield.text];
        [vc addImage:self.image];
        // Present Compose View Controller
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)shareButtonPressed:(id)sender {
    
    // Activity Items
    UIImage *image = self.image;
    NSString *caption = self.captionTextfield.text;
    NSArray *activityItems = @[image, caption];
    // Initialize Activity View Controller
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    // Present Activity View Controller
    [self presentViewController:vc animated:YES completion:nil];
}
@end
