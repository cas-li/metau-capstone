//
//  ProfileViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

#import "ProfileViewController.h"
#import "Vent.h"
#import "VentCell.h"
#import "SpotifyAPIManager.h"
#import "VWHelpers.h"
#import "UIViewController+ErrorAlertPresenter.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Vent *> *arrayOfVents;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ventCountLabel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isRefreshing;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", [VWUser currentUser].username];
    self.screenNameLabel.text = [VWUser currentUser].screenName;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    [self loadData];
}

- (void)beginRefresh {
    self.isRefreshing = YES;
    [self loadData];
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"getPersonalVents"
                       withParameters:@{@"limit":@20, @"currentUserId":[VWUser currentUser].objectId}
                                block:^(id vents, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
            NSLog(@"%@", vents);
            NSArray *arrayOfVents = CAST_TO_CLASS_OR_NIL(vents, NSArray);
            if (!arrayOfVents) {
                NSLog(@"Not an array");
                return;
            }
            strongSelf.arrayOfVents = arrayOfVents.mutableCopy;
            [strongSelf.tableView reloadData];

            if (strongSelf.isRefreshing) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.isRefreshing = NO;
            }
          
        }
        else {
            NSLog(@"there was an error, u suck");
            if (strongSelf.isRefreshing) {
                [strongSelf.refreshControl endRefreshing];
                strongSelf.isRefreshing = NO;
                [strongSelf presentErrorMessageWithTitle:@"Error" message:@"There was an error refreshing."];

            }
        }
    }];
    
    [PFCloud callFunctionInBackground:@"getPersonalVentCount"
                       withParameters:@{@"currentUserId":[VWUser currentUser].objectId}
                                block:^(id vents, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
            NSNumber *ventsNumber = CAST_TO_CLASS_OR_NIL(vents, NSNumber);
            if (!vents) {
                NSLog(@"vents not a number");
                return;
            }
            self.ventCountLabel.text = [NSString stringWithFormat:@"%@%@", @"Vent Count: " , [ventsNumber stringValue]];
        }
        else {
            NSLog(@"there was an error, u suck");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfVents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VentCell" forIndexPath:indexPath];

    cell.vent = self.arrayOfVents[indexPath.row];

    return cell;
}

- (void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint p = [gestureRecognizer locationInView:self.tableView];

        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.isHighlighted) {
                NSLog(@"long press on table view at section %ld row %d", (long)indexPath.section, indexPath.row);
                Vent *currentVent = self.arrayOfVents[indexPath.row];
                if (currentVent.trackUri != nil) {
                    [[SpotifyAPIManager shared] playTrack:currentVent.trackUri startTimestamp:[currentVent.startTimestamp intValue] endTimestamp:[currentVent.endTimestamp intValue]];
                }
            }
        }
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [[SpotifyAPIManager shared] pause];
    }
}

@end
