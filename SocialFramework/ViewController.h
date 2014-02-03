//
//  ViewController.h
//  SocialFramework
//
//  Created by Sunayna Jain on 2/3/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *captionTextfield;

@property (weak, nonatomic) IBOutlet UIImageView *sharedImageView;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;


@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)facebookButtonPressed:(id)sender;

- (IBAction)shareButtonPressed:(id)sender;


@end
