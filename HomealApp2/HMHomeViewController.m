//
//  HMHomeViewController.m
//  HomealApp2
//
//  Created by Ling Hung on 8/14/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import "HMHomeViewController.h"
#import "HMAppDelegate.h"

@interface HMHomeViewController ()

@end

@implementation HMHomeViewController

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

#pragma mark = IBActions

- (IBAction)filterBarButtonItem:(UIBarButtonItem *)sender {
    [[self drawControllerFromAppDelegate] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Drawercontroller
-(MMDrawerController *) drawControllerFromAppDelegate
{
    HMAppDelegate *appDelegate = (HMAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.drawController;
}
@end
