//
//  HMMeViewController.m
//  HomealApp2
//
//  Created by Ling Hung on 8/14/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import "HMMeViewController.h"

@interface HMMeViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameUILabel;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;
@property (strong, nonatomic) IBOutlet UILabel *emailUILabel;

@property (nonatomic) int currentPhotoIndex;

@end

@implementation HMMeViewController

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
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Helper Methods
- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0 ) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[@"image"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)updateView {
    self.nameUILabel.text = self.photo[@"user"][@"profile"][@"name"];
    self.emailUILabel.text = self.photo[@"user"][@"profile"][@"email"];
}

@end
