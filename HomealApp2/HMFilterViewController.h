//
//  HMFilterViewController.h
//  HomealApp2
//
//  Created by Ling Hung on 8/16/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface HMFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
