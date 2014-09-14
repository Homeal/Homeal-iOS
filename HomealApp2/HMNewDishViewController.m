//
//  HMNewDishViewController.m
//  HomealApp2
//
//  Created by Ling Hung on 8/14/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import "HMNewDishViewController.h"

@interface HMNewDishViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *dishUIImageView;
@property (strong, nonatomic) IBOutlet UITextField *dishNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ingredientTextField;
@property (strong, nonatomic) IBOutlet UITextField *foodTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UITextField *unitPriceTextField;
@property (strong, nonatomic) IBOutlet UITextField *foodIntroTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *paymentSegmentedButton;
@property (strong, nonatomic) IBOutlet UILabel *imagePlaceHolderLabel;

@property (strong, nonatomic) NSMutableArray *photos; // Of UIImages

@end

@implementation HMNewDishViewController

- (NSMutableArray *)photos {
    if(!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dishNameTextField.delegate = self;
    self.ingredientTextField.delegate = self;
    self.foodTypeTextField.delegate = self;
    self.foodIntroTextField.delegate = self;
    self.quantityTextField.delegate = self;
    self.unitPriceTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cameraBarButtonItem:(UIBarButtonItem *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)createDishButton:(UIButton *)sender
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        NSString *paymentString = [[NSString alloc] init];
        if (self.paymentSegmentedButton.isEnabled) {
            paymentString = @"Cash";
        } else {
            paymentString = @"Credit Card";
        }
        PFUser *user = [PFUser currentUser];
        NSData *imageData = UIImageJPEGRepresentation(self.dishUIImageView.image, 0.8);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                PFObject *photo = [PFObject objectWithClassName:kHMPhotoClassKey];
                [photo setObject:[PFUser currentUser] forKey:kHMPhotoUserKey];
                [photo setObject:photoFile forKey:kHMPhotoPictureKey];
                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"Photo saved successfully");
                }];
            }
        }];
        
        PFObject *dish = [[PFObject alloc] initWithClassName:@"Dish"];
        [dish addObject:self.dishNameTextField.text forKey:@"dishName"];
        [dish addObject:self.unitPriceTextField.text forKey:@"unitPrice"];
        [dish addObject:self.foodTypeTextField.text forKey:@"foodType"];
        [dish addObject:photoFile forKey:@"foodImage"];
        [dish addObject:self.ingredientTextField.text forKey:@"ingredient"];
        [dish addObject:paymentString forKey:@"paymentMethod"];
        [dish saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Create New Dish Fail" message:@"Your new dish can't be saved, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
        [user addObject:dish forKey:@"dish"];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save user fail" message:@"Save fail, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                NSLog(@"Save user failed! Cause: %@", error);
            }
        }];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(!image) image = info[UIImagePickerControllerOriginalImage];
    
    [self.photos addObject:image];
    self.dishUIImageView.image = image;
    self.imagePlaceHolderLabel.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
