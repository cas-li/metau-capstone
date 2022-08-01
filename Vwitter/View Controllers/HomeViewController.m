//
//  HomeViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Vent.h"
#import "VentCell.h"
#import "VentAudience.h"
#import "UIViewController+ErrorAlertPresenter.h"
#import "VWUser.h"
#import "VWHelpers.h"
#import "SpotifyAPIManager.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Vent *> *arrayOfVents;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isRefreshing;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
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
    [PFCloud callFunctionInBackground:@"fetchHomeTimeline"
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
}
- (IBAction)didTapLogout:(id)sender {
    [VWUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog (@"Error logging user out");
        }
        else {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
            NSLog(@"User logged out successfully");
            
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfVents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VentCell" forIndexPath:indexPath];

    cell.vent = self.arrayOfVents[indexPath.row];

    return cell;
}

-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
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
                    [[SpotifyAPIManager shared] playTrack:currentVent.trackUri];
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
