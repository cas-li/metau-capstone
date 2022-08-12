//
//  SearchUsersViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>

#import "SearchUsersViewController.h"
#import "UserCell.h"
#import "VWUser.h"
#import "UserCellViewModel.h"
#import "Follow.h"
#import "VWHelpers.h"
#import "GroupDetails.h"
#import "GroupCell.h"
#import "UIViewController+ErrorAlertPresenter.h"
#import "VentCell.h"

@interface SearchUsersViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UserCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *arrayOfUserCellViewModelsAndGroups;
@property (nonatomic, readwrite) int requestCount;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation SearchUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.arrayOfUserCellViewModelsAndGroups = [[NSMutableArray alloc] init];
    [self loadSearchResults:nil];
    
    self.searchBar.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadSearchResults:nil];
}

- (void)beginRefresh {
    self.isRefreshing = YES;
    [self loadSearchResults:nil];
}

- (void)loadSearchResults:(NSString *_Nullable)searchString {
    const int currentRequestCount = self.requestCount++;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = @{@"limit":@20, @"currentUserId":[VWUser currentUser].objectId}.mutableCopy;
    if (searchString && ![searchString isEqualToString:@""]) {
        params[@"searchString"] = searchString;
    }
    [PFCloud callFunctionInBackground:@"fetchSearchItems"
                       withParameters:params
                                block:^(id results, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (strongSelf.requestCount > currentRequestCount + 1) {
            NSLog(@"Cancelled search because a new search is already in progress");
            return;
        }
        if (!error) {
            NSLog(@"%@", results);
            NSArray *_Nullable resultsArray = CAST_TO_CLASS_OR_NIL(results, NSArray);
            if (!resultsArray) {
                return;
            }
            [strongSelf.arrayOfUserCellViewModelsAndGroups removeAllObjects];
            for (id object in resultsArray) {
                if ([object isKindOfClass:[GroupDetails class]]) {
                    [strongSelf.arrayOfUserCellViewModelsAndGroups addObject:object];
                    continue;
                }
                else if ([object isKindOfClass:[Vent class]]) {
                    [strongSelf.arrayOfUserCellViewModelsAndGroups addObject:object];
                    continue;
                }
                NSDictionary *_Nullable dictionary = CAST_TO_CLASS_OR_NIL(object, NSDictionary);
                if (!dictionary) {
                    NSLog(@"not a dictionary");
                    continue;
                }
                VWUser *_Nullable currentUser = CAST_TO_CLASS_OR_NIL(object[@"user"], VWUser);
                if (!currentUser) {
                    NSLog(@"not a user");
                    continue;
                }
                NSNumber *_Nullable isFollowing = CAST_TO_CLASS_OR_NIL(object[@"isFollowing"], NSNumber);
                if (!isFollowing) {
                    NSLog(@"not a number");
                    continue;
                }
                UserCellViewModel *newUCVW = [[UserCellViewModel alloc] initWithUser:currentUser withUserId:currentUser.objectId withUsername:currentUser.username withIsFollowing:isFollowing.boolValue];
                [strongSelf.arrayOfUserCellViewModelsAndGroups addObject:newUCVW];
            }
            
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfUserCellViewModelsAndGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.arrayOfUserCellViewModelsAndGroups[indexPath.row] isKindOfClass:[GroupDetails class]]) {
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
        cell.group = self.arrayOfUserCellViewModelsAndGroups[indexPath.row];
        return cell;
    }
    else if ([self.arrayOfUserCellViewModelsAndGroups[indexPath.row] isKindOfClass:[UserCellViewModel class]]){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
        cell.userCellViewModel = self.arrayOfUserCellViewModelsAndGroups[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }
    else {
        VentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VentCell" forIndexPath:indexPath];
        cell.vent = self.arrayOfUserCellViewModelsAndGroups[indexPath.row];
        return cell;
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self loadSearchResults:searchText];
}

- (void)didFollowUserWithViewModel:(UserCellViewModel *)viewModel {

    [PFCloud callFunctionInBackground:@"didToggleFollow"
                       withParameters:@{@"followingUserId":viewModel.user.objectId, @"currentUserId":[VWUser currentUser].objectId}
                                block:^(id result, NSError *error) {
        if (!error) {
            NSNumber *numberResult = result;
            viewModel.isFollowing = numberResult.boolValue;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"there was an error, u suck");
        }
    }];
}

@end
