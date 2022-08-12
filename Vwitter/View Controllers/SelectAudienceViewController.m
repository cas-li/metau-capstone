//
//  SelectAudienceViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/8/22.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "SelectAudienceViewController.h"
#import "Follow.h"
#import "AudienceMemberCell.h"
#import "Vent.h"
#import "VentAudience.h"
#import "VWHelpers.h"
#import "GroupCell.h"
#import "UIViewController+ErrorAlertPresenter.h"
#import "SpotifyAPIManager.h"

@interface SelectAudienceViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postVentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<VWUser *> *arrayOfUserAudienceMembers;
@property (strong, nonatomic) NSMutableArray<GroupDetails *> *arrayOfGroupAudienceMembers;
@property (strong, nonatomic) NSMutableSet *arrayOfSelectedAudience;

@end

@implementation SelectAudienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.arrayOfSelectedAudience = [[NSMutableSet alloc] init];
    self.tableView.allowsMultipleSelection = YES;
    [self loadData];
    
    self.postVentButton.layer.cornerRadius = 20;
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"fetchPotentialAudienceUsers"
                       withParameters:@{@"limit":@20, @"currentUserId":[VWUser currentUser].objectId}
                                block:^(id follows, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
            NSLog(@"%@", follows);
            NSArray *arrayOfFollowers = CAST_TO_CLASS_OR_NIL([follows valueForKey:@"currentUser"], NSArray);
            strongSelf.arrayOfUserAudienceMembers = arrayOfFollowers.mutableCopy;
            [strongSelf.tableView reloadData];
            
        }
        else {
            NSLog(@"there was an error, u suck");
        }
    }];
    
    [PFCloud callFunctionInBackground:@"fetchPotentialAudienceGroups"
                       withParameters:@{@"limit":@20, @"groupAuthorUserId":[VWUser currentUser].objectId}
                                block:^(id groups, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
            NSLog(@"%@", groups);
            NSArray *arrayOfGroups = groups;
            strongSelf.arrayOfGroupAudienceMembers = arrayOfGroups.mutableCopy;
            [strongSelf.tableView reloadData];
            
        }
        else {
            NSLog(@"there was an error, u suck");
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return [self.arrayOfGroupAudienceMembers count];
    }
    else {
        return [self.arrayOfUserAudienceMembers count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Groups";
    }
    else {
        return @"Users";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
        cell.group = self.arrayOfGroupAudienceMembers[indexPath.row];
        return cell;
    }
    else {
        AudienceMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudienceMemberCell" forIndexPath:indexPath];
        cell.user = self.arrayOfUserAudienceMembers[indexPath.row];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (indexPath.section == 0) {
        [self.arrayOfSelectedAudience addObject:self.arrayOfGroupAudienceMembers[indexPath.row]];
    }
    else {
        [self.arrayOfSelectedAudience addObject:self.arrayOfUserAudienceMembers[indexPath.row]];
    }
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        [self.arrayOfSelectedAudience removeObject:self.arrayOfGroupAudienceMembers[indexPath.row]];
    }
    else {
        [self.arrayOfSelectedAudience removeObject:self.arrayOfUserAudienceMembers[indexPath.row]];
    }
    
}

- (IBAction)didTapVent:(id)sender {
    
    if (![VWUser currentUser].objectId) {
        [self presentErrorMessageWithTitle:@"Error" message:@"You cannot currently vent. Please try again."];
        return;
    }
    else if (!self.ventContent) {
        [self presentErrorMessageWithTitle:@"Error" message:@"Vent content undefined."];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableArray *ventAudiences = [NSMutableArray arrayWithArray:[self.arrayOfSelectedAudience allObjects]];
    
    NSMutableArray *ventAudiencesIds = [ventAudiences valueForKey:@"objectId"];
    
    NSMutableDictionary *params = @{
        @"currentUserId":[VWUser currentUser].objectId,
        @"ventContent":self.ventContent,
        @"ventAudiencesIds":ventAudiencesIds
    }.mutableCopy;
    
    if (self.selectedTrack.uriString) {
        params[@"selectedTrackUri"] = self.selectedTrack.uriString;

    }
    if (self.selectedTrack.startTimestamp && self.selectedTrack.endTimestamp) {
        params[@"startTimestamp"] = self.selectedTrack.startTimestamp;
        params[@"endTimestamp"] = self.selectedTrack.endTimestamp;
    }
    
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"postVent"
                       withParameters:params
                                block:^(id groups, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
            [[SpotifyAPIManager shared] pause];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            
        }
        else {
            NSLog(@"there was an error, u suck");
            [[SpotifyAPIManager shared] pause];
            [self presentErrorMessageWithTitle:@"Error" message:@"Your vent was not posted."];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
