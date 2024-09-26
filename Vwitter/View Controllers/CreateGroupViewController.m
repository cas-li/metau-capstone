//
//  CreateGroupViewController.m
//  Vwitter
//
//  Created by Christina Li on 7/20/22.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "CreateGroupViewController.h"
#import "Follow.h"
#import "AudienceMemberCell.h"
#import "GroupDetails.h"
#import "GroupMembership.h"
#import "VWHelpers.h"
#import "UIViewController+ErrorAlertPresenter.h"

@interface CreateGroupViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<VWUser *> *arrayOfUserAudienceMembers;
@property (strong, nonatomic) NSMutableSet *arrayOfSelectedUserAudience;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.arrayOfSelectedUserAudience = [[NSMutableSet alloc] init];
    self.tableView.allowsMultipleSelection = YES;
    [self loadData];
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

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfUserAudienceMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudienceMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudienceMemberCell" forIndexPath:indexPath];

    cell.user = self.arrayOfUserAudienceMembers[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = NO;
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.arrayOfSelectedUserAudience addObject:self.arrayOfUserAudienceMembers[indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryView.hidden = YES;
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    
    [self.arrayOfSelectedUserAudience removeObject:self.arrayOfUserAudienceMembers[indexPath.row]];

}

- (IBAction)didCreateGroup:(id)sender {
    
    if (![VWUser currentUser].objectId) {
        [self presentErrorMessageWithTitle:@"Error" message:@"You cannot currently create a group. Please try again."];
        return;
    }
    else if ([self.groupNameField.text isEqualToString:@""]) {
        [self presentErrorMessageWithTitle:@"Error" message:@"Group name cannot be empty."];
        return;
    }
    else if ([self.arrayOfSelectedUserAudience count] == 0) {
        [self presentErrorMessageWithTitle:@"Error" message:@"Group cannot have 0 members."];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableArray *groupMemberships = [NSMutableArray arrayWithArray:[self.arrayOfSelectedUserAudience allObjects]];
    
    NSMutableArray *groupMembershipIds = [groupMemberships valueForKey:@"objectId"];
    
    __weak typeof(self) weakSelf = self;
    [PFCloud callFunctionInBackground:@"createGroup"
                       withParameters:@{@"authorId":[VWUser currentUser].objectId, @"groupName":self.groupNameField.text, @"groupMembershipIds":groupMembershipIds}
                                block:^(id groups, NSError *error) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            NSLog(@"I got killed!");
            return;
        }
        if (!error) {
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            UINavigationController *navigationController = strongSelf.navigationController;
            [navigationController popViewControllerAnimated:YES];
            
        }
        else {
            NSLog(@"there was an error with group creation, u suck");
            [self presentErrorMessageWithTitle:@"Error" message:@"Group creation failed"];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            UINavigationController *navigationController = strongSelf.navigationController;
            [navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
