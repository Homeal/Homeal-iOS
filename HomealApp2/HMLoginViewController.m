//
//  HMLoginViewController.m
//  HomealApp2
//
//  Created by Ling Hung on 8/12/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import "HMLoginViewController.h"

@interface HMLoginViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableData *imageData;

@end

@implementation HMLoginViewController

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
    self.activityIndicator.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self updateUserInformation];
        [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark = IBActions
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships",
                                  @"user_birthday", @"user_location", @"user_relationship_details"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:
     ^(PFUser *user, NSError *error) {
         [self.activityIndicator stopAnimating];
         self.activityIndicator.hidden = YES;
         if (!user){
             if (!error){
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The Facebook Login was canceled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
             } else {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
             }
         } else {
             [self updateUserInformation];
             [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
         }
     }];
}

#pragma mark - Helper Method

- (void) updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error){
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            if (userDictionary[@"name"]){
                userProfile[kHMUserProfileNameKey] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"]){
                userProfile[kHMUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"][@"name"]){
                userProfile[kHMUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if (userDictionary[@"gender"]){
                userProfile[kHMUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"]){
                userProfile[kHMUserProfileBirthdayKey] = userDictionary[@"birthday"];
            }
            if (userDictionary[@"interested_in"]){
                userProfile[kHMUserProfileInterestedKey] = userDictionary[@"interested_in"];
            }
            if (userDictionary[@"email"]){
                userProfile[kHMUserProfileInterestedKey] = userDictionary[@"email"];
            }
            if ([pictureURL absoluteString]){
                userProfile[kHMUserProfilePictureURL] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:kHMUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            [self requestImage];
        } else {
            NSLog(@"Error in FB request %@", error);
        }
    }];
}

- (void)uploadPFFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (!imageData){
        NSLog(@"imageData was not found.");
        return;
    }
    
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
}

- (void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kHMPhotoClassKey];
    [query whereKey:kHMPhotoUserKey equalTo:[PFUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
       if (number == 0)
       {
           PFUser *user = [PFUser currentUser];
           self.imageData = [[NSMutableData alloc] init];
           NSURL *profilePcitureURL = [NSURL URLWithString:user[kHMUserProfileKey][kHMUserProfilePictureURL]];
           NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePcitureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
           NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
           if (!urlConnection) {
               NSLog(@"Failed to Download Picture");
           }
       }
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
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
@end
