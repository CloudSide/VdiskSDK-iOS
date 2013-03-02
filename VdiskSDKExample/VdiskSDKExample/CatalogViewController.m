//
//  VdiskSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Bruce Chen (weibo: @一个开发者) on 12-6-15.
//
//  Copyright (c) 2012 Sina Vdisk. All rights reserved.
//

#import "CatalogViewController.h"
#import "VdiskSDK.h"
#import "AccountInfoViewController.h"
#import "MetadataViewController.h"
#import "UploadFileViewController.h"
#import "LoadFileViewController.h"
#import "RestoreViewController.h"
#import "SearchViewController.h"
#import "SharesViewController.h"
#import "CopyViewController.h"
#import "CreateFolderViewController.h"
#import "DeleteViewController.h"
#import "MoveViewController.h"
#import "RevisionsViewController.h"
#import "ThumbnailsViewController.h"
#import "MediaFilesViewController.h"
#import "CopyRefViewController.h"
#import "CopyFromCopyRefViewController.h"
#import "MediaFilesFromRefViewController.h"
#import "UploadBigFileViewController.h"
#import "BlitzViewController.h"
#import "RecommendViewController.h"
#import "ShareFileToFriendsViewController.h"


@interface CatalogViewController ()

- (void)onUnlinkButtonPressed:(id)sender;

@end

@implementation CatalogViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
        
        //self.title = @"Vdisk API Catalog";
        self.title = @"Catalog";
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Unlink" style:UIBarButtonItemStylePlain target:self action:@selector(onUnlinkButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [rightBtn release];
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"RefreshLink" style:UIBarButtonItemStylePlain target:self action:@selector(onRefreshLinkButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    [leftBtn release];
    
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    
    switch (section) {
            
        case 0:
            rows = 1;
            break;
        case 1:
            rows = 12;
            break;
        case 2:
            rows = 5;
            break;
        case 3:
            rows = 1;
            break;
        case 4:
            rows = 2;
            break;
        default:
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CatalogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"Account info";
                break;
            default:
                break;
        }
        
    } else if (indexPath.section == 1) {
    
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"Upload files";
                break;
            case 1:
                cell.textLabel.text = @"Load files";
                break;
            case 2:
                cell.textLabel.text = @"Metadata";
                break;
            case 3:
                cell.textLabel.text = @"Revisions";
                break;
            case 4:
                cell.textLabel.text = @"Restore";
                break;
            case 5:
                cell.textLabel.text = @"Search";
                break;
            case 6:
                cell.textLabel.text = @"Shares";
                break;
            case 7:
                cell.textLabel.text = @"Thumbnails";
                break;
            case 8:
                cell.textLabel.text = @"Streaming Media Files";
                break;
            case 9:
                cell.textLabel.text = @"Create a copy_ref";
                break;
            case 10:
                cell.textLabel.text = @"Upload big files";
                break;
            case 11:
                cell.textLabel.text = @"Blitz files";
                break;
            default:
                break;
        } 
        
    } else if (indexPath.section == 2) {
    
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"Copy";
                break;    
            case 1:
                cell.textLabel.text = @"Copy from copy_ref";
                break;
            case 2:
                cell.textLabel.text = @"Create folder";
                break;
            case 3:
                cell.textLabel.text = @"Delete";
                break;
            case 4:
                cell.textLabel.text = @"Move";
                break;
            default:
                break;
        }
    
    } else if (indexPath.section == 3) {
    
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"Media from copy_ref";
                break;
            default:
                break;
        }
        
    } else if (indexPath.section == 4) {
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"PublicSharesList";
                break;
            case 1:
                cell.textLabel.text = @"ShareFileToFriends";
                break;
            case 2:
                cell.textLabel.text = @"2";
                break;
            case 3:
                cell.textLabel.text = @"3";
                break;
            case 4:
                cell.textLabel.text = @"4";
                break;
            default:
                break;
        }
    }
        
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    switch (section) {
        case 0:
            sectionTitle = @"Vdisk accounts";
            break;
        case 1:
            sectionTitle = @"Files and metadata";
            break;
        case 2:
            sectionTitle = @"File operations";
            break;
        case 3:
            sectionTitle = @"Share operations";
            break;
        case 4:
            sectionTitle = @"Shares";
            break;
        default:
            sectionTitle = @"";
            break;
    }
    
    return sectionTitle;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            AccountInfoViewController *accountInfoViewController = [[[AccountInfoViewController alloc] initWithNibName:@"AccountInfoViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:accountInfoViewController animated:YES];
        }
        
    } else if (indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            
            UploadFileViewController *uploadFileViewController = [[[UploadFileViewController alloc] initWithNibName:@"UploadFileViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:uploadFileViewController animated:YES];
            
        } else if (indexPath.row == 1) {
            
            LoadFileViewController *loadFileViewController = [[[LoadFileViewController alloc] initWithNibName:@"LoadFileViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:loadFileViewController animated:YES];
            
        } else if (indexPath.row == 2) {
            
            MetadataViewController *metadataViewController = [[[MetadataViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            [self.navigationController pushViewController:metadataViewController animated:YES];
            
        } else if (indexPath.row == 3) {
            
            RevisionsViewController *revisionsViewController = [[[RevisionsViewController alloc] initWithNibName:@"RevisionsViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:revisionsViewController animated:YES];

        } else if (indexPath.row == 4) {
            
            RestoreViewController *restoreViewController = [[[RestoreViewController alloc] initWithNibName:@"RestoreViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:restoreViewController animated:YES];
            
        } else if (indexPath.row == 5) {
            
            SearchViewController *searchViewController = [[[SearchViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            [self.navigationController pushViewController:searchViewController animated:YES];
            
        } else if (indexPath.row == 6) {
            
            SharesViewController *shareViewController = [[[SharesViewController alloc] initWithNibName:@"SharesViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:shareViewController animated:YES];
        
        } else if (indexPath.row == 7) {
        
            ThumbnailsViewController *thumbnailsViewController = [[[ThumbnailsViewController alloc] initWithNibName:@"ThumbnailsViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:thumbnailsViewController animated:YES];
            
        } else if (indexPath.row == 8) {
            
            MediaFilesViewControllerViewController *mediaFilesViewControllerViewController = [[[MediaFilesViewControllerViewController alloc] initWithNibName:@"MediaFilesViewControllerViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:mediaFilesViewControllerViewController animated:YES];
            
        } else if (indexPath.row == 9) {
            
            CopyRefViewController *copyRefViewController = [[[CopyRefViewController alloc] initWithNibName:@"CopyRefViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:copyRefViewController animated:YES];
            
        } else if (indexPath.row == 10) {
            
            UploadBigFileViewController *uploadBigFileViewController = [[[UploadBigFileViewController alloc] initWithNibName:@"UploadBigFileViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:uploadBigFileViewController animated:YES];
            
        } else if (indexPath.row == 11) {
            
            BlitzViewController *blitzViewController = [[[BlitzViewController alloc] initWithNibName:@"BlitzViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:blitzViewController animated:YES];
        }
        
    } else if (indexPath.section == 2) {
    
        if (indexPath.row == 0) {
            
            CopyViewController *copyViewController = [[[CopyViewController alloc] initWithNibName:@"CopyViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:copyViewController animated:YES];
            
        } else if (indexPath.row == 1) {
            
            CopyFromCopyRefViewController *copyFromCopyRefViewController = [[[CopyFromCopyRefViewController alloc] initWithNibName:@"CopyFromCopyRefViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:copyFromCopyRefViewController animated:YES];
            
        } else if (indexPath.row == 2) {
            
            CreateFolderViewController *createFolderViewController = [[[CreateFolderViewController alloc] initWithNibName:@"CreateFolderViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:createFolderViewController animated:YES];
            
        } else if (indexPath.row == 3) {
            
            DeleteViewController *deleteViewController = [[[DeleteViewController alloc] initWithNibName:@"DeleteViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:deleteViewController animated:YES];
            
        } else if (indexPath.row == 4) {
            
            MoveViewController *moveViewController = [[[MoveViewController alloc] initWithNibName:@"MoveViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:moveViewController animated:YES];
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            MediaFilesFromRefViewController *mediaFilesFromRefViewController = [[[MediaFilesFromRefViewController alloc] initWithNibName:@"MediaFilesFromRefViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:mediaFilesFromRefViewController animated:YES];
            
        } else if (indexPath.row == 1) {
            
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            RecommendViewController *recommendViewController = [[[RecommendViewController alloc] init] autorelease];
            [self.navigationController pushViewController:recommendViewController animated:YES];
            
        } else if (indexPath.row == 1) {
            
            ShareFileToFriendsViewController *shareFileToFriendsViewController = [[[ShareFileToFriendsViewController alloc] initWithNibName:@"ShareFileToFriendsViewController" bundle:nil] autorelease];
            
            [self.navigationController pushViewController:shareFileToFriendsViewController animated:YES];
            
        } else if (indexPath.row == 2) {
            
            
        } else if (indexPath.row == 3) {
            
            
        } else if (indexPath.row == 4) {
            
            
        }
    }
}

#pragma mark - Private 

- (void)onUnlinkButtonPressed:(id)sender {
    
    [[VdiskSession sharedSession] unlink];
}

- (void)onRefreshLinkButtonPressed:(id)sender {
    
    [[VdiskSession sharedSession] refreshLink];
}

@end
