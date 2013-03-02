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

#import "RevisionsViewController.h"
#import "VdiskSDK.h"

@interface RevisionsViewController () <VdiskRestClientDelegate> {

    VdiskRestClient *_vdiskRestClient;
    NSMutableArray *_revisions;
}

@end

@implementation RevisionsViewController

@synthesize filePathTextField = _filePathTextField;
@synthesize loadButton = _loadButton;

- (void)dealloc {

    [_loadButton release];
    [_filePathTextField release];
    
    [_vdiskRestClient cancelAllRequests];
    [_vdiskRestClient setDelegate:nil];
    [_vdiskRestClient release];
    
    [_revisions release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    
        self.title = @"revisions";
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        
    }
    
    return self;
}

- (IBAction)onLoadButtonPressed:(id)sender {

    [_filePathTextField resignFirstResponder];
    
    if ([_filePathTextField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty path" message:@"Please input the file path" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
        
        return;
    }
    
    [_vdiskRestClient loadRevisionsForFile:_filePathTextField.text limit:1000];
    
    [_loadButton setEnabled:NO];
    [_loadButton setTitle:@"Loading..." forState:UIControlStateNormal];
    
}

#pragma mark - VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)client loadedRevisions:(NSArray *)revisions forFile:(NSString *)path {

    if (_revisions != nil) {
        
        [_revisions release], _revisions = nil;
    }
    
    _revisions = [[NSMutableArray arrayWithArray:revisions] retain];
    
    [self.tableView reloadData];
    
    [_loadButton setEnabled:YES];
    [_loadButton setTitle:@"Load revisions" forState:UIControlStateNormal];
}

- (void)restClient:(VdiskRestClient *)client loadRevisionsFailedWithError:(NSError *)error {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR!!" message:[NSString stringWithFormat:@"Error!\n----------------\nerrno:%d\n%@\%@\n----------------", error.code, error.localizedDescription, [error userInfo]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    [_loadButton setEnabled:YES];
    [_loadButton setTitle:@"Load revisions" forState:UIControlStateNormal];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_revisions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell setUserInteractionEnabled:NO];
    
    VdiskMetadata *metadata = (VdiskMetadata *)[_revisions objectAtIndex:indexPath.row];
    
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-dd HH:mm:ss"];
    NSString *lastDateString = [formatter stringFromDate:metadata.lastModifiedDate];
    [formatter release];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(rev:%@)", metadata.filename, metadata.rev];
    cell.detailTextLabel.text = lastDateString;
    
    return cell;
}


@end
