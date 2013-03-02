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
#import "MetadataViewController.h"
#import "VdiskSDK.h"

@interface MetadataViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_vdiskRestClient;
    VdiskMetadata *_metadata;
}

- (void)onReloadButtonPressed:(id)sender;

@end

@implementation MetadataViewController

@synthesize path = _path;

- (void)onReloadButtonPressed:(id)sender {

    if (_path == nil) {
        
        _path = @"/";
    }
    
    [_vdiskRestClient loadMetadata:_path];
    //[_vdiskRestClient loadMetadata:_path withHash:@"d9a7cb23d360661dae590b523f7a565f"];
    
    self.navigationItem.rightBarButtonItem.title = @"Loading...";
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)dealloc {

    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_metadata release];
    
    [_path release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
    
        self.title = @"Metadata";
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(onReloadButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [rightBtn release];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self onReloadButtonPressed:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_metadata.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MetadataCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    VdiskMetadata *metadata = (VdiskMetadata *)[_metadata.contents objectAtIndex:indexPath.row];
    
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
            
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-dd HH:mm:ss"];
    NSString *lastDateString = [formatter stringFromDate:metadata.lastModifiedDate];
    [formatter release];
    
    cell.textLabel.text = metadata.filename;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", lastDateString, metadata.humanReadableSize];
    
    //NSLog(@"%@", metadata.fileSha1);
    
    if ([metadata isDirectory]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setUserInteractionEnabled:YES];
        
        cell.detailTextLabel.text = lastDateString;
        
    } else {
        
        [cell setUserInteractionEnabled:NO];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    
    switch (section) {
            
        case 0:
            sectionTitle = _metadata.path;
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
    
     VdiskMetadata *metadata = (VdiskMetadata *)[_metadata.contents objectAtIndex:indexPath.row];
    
    if ([metadata isDirectory]) {
    
        MetadataViewController *metadataViewController = [[[MetadataViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        metadataViewController.path = metadata.path;
        [self.navigationController pushViewController:metadataViewController animated:YES];
    }
}

#pragma mark - VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)client loadedMetadata:(VdiskMetadata *)metadata {

    self.navigationItem.rightBarButtonItem.title = @"Reload";
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    if (_metadata != nil) {
        
        [_metadata release], _metadata = nil;
    }
    
    _metadata = [metadata retain];
    
    [self.tableView reloadData];
}

- (void)restClient:(VdiskRestClient *)client metadataUnchangedAtPath:(NSString *)path {

    self.navigationItem.rightBarButtonItem.title = @"Reload";
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)restClient:(VdiskRestClient *)client loadMetadataFailedWithError:(NSError *)error {

    self.navigationItem.rightBarButtonItem.title = @"Reload";
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end
