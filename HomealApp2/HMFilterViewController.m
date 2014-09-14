//
//  HMFilterViewController.m
//  HomealApp2
//
//  Created by Ling Hung on 8/16/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import "HMFilterViewController.h"
#import "HMHomeViewController.h"
#import "HMAppDelegate.h"

@interface HMFilterViewController ()

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) UINavigationController *homeNavigationController;

@end

@implementation HMFilterViewController

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (!self.viewControllers){
        self.viewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!self.homeNavigationController){
        MMDrawerController *drawController = [self drawControllerFromAppDelegate];
        self.homeNavigationController = (UINavigationController *)drawController.centerViewController;
        [self.viewControllers addObject:self.homeNavigationController];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewControllers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - DrawController Helper
-(MMDrawerController *)drawControllerFromAppDelegate
{
    HMAppDelegate *appDelegate = (HMAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.drawController;
}

@end
