//
//  PageVC.m
//  BookShelfExample
//
//  Created by Prav on 27/12/2016.
//  Copyright © 2016 Michał Zaborowski. All rights reserved.
//

#import "PageVC.h"


static NSInteger const kNoOfItems = 21;
static NSString *const reuseIdentifier = @"cell";

@interface PageVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *aCollectionView;
@property (strong, nonatomic) ASJCollectionViewFillLayout *aLayout;
@property (copy, nonatomic) NSArray *objects;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtextLabel;

- (void)setup;
- (void)setupCollectionViewData;
- (void)setupLayout;
- (IBAction)directionChanged:(id)sender;


@end

@implementation PageVC

@synthesize pageObject,noOfitems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    self.aCollectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.titleName.text = [self.pageObject valueForKey:@"name"];
}

#pragma mark - Setup

- (void)setup
{
//    [self setupCollectionViewData];
    [self setupLayout];
}

- (void)setupLayout
{
    _aLayout = [[ASJCollectionViewFillLayout alloc] init];
    _aLayout.delegate = self;
    _aLayout.direction = ASJCollectionViewFillLayoutVertical;
    _aCollectionView.collectionViewLayout = _aLayout;
    _aLayout.stretchesLastItems = NO;
}

- (void)setupCollectionViewData
{
    noOfitems = (int)[self.pageObject count];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i=0; i<noOfitems; i++)
    {
        [temp addObject:[NSString stringWithFormat:@"Item %d", i+1]];
    }
    _objects = [NSArray arrayWithArray:temp];
}

- (IBAction)directionChanged:(id)sender
{
    NSInteger selectedSegmentIndex = _directionSegmentedControl.selectedSegmentIndex;
    _aLayout.direction = (ASJCollectionViewFillLayoutDirection)selectedSegmentIndex;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.pageObject objectForKey:@"Pages"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
  
    cell.backgroundColor = [UIColor whiteColor];

    UILabel *lbl0 = (UILabel *)[cell viewWithTag:8];

    UILabel *lbl = (UILabel *)[cell viewWithTag:2];
    lbl.text = [[[self.pageObject objectForKey:@"Pages"] objectAtIndex:indexPath.row] valueForKey:@"no"];
    if ([lbl.text length] == 0) {
        lbl0.hidden = YES;
        lbl.hidden = YES;
    } else{
        lbl0.hidden = NO;
        lbl.hidden = NO;
    }
    
    
    UILabel *lbl1 = (UILabel *)[cell viewWithTag:4];
    lbl1.text = [[[self.pageObject objectForKey:@"Pages"] objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    UILabel *lbl2 = (UILabel *)[cell viewWithTag:6];
    lbl2.text = [[[self.pageObject objectForKey:@"Pages"] objectAtIndex:indexPath.row] valueForKey:@"subtext"];
    
    if ([lbl2.text isEqualToString:@"செய்யுள்"]) {
        cell.backgroundColor = [UIColor colorWithRed:0.224 green:0.596 blue:0.404 alpha:1.00];
    } else if ([lbl2.text isEqualToString:@"உரைநடை"]) {
        cell.backgroundColor = [UIColor colorWithRed:0.761 green:0.133 blue:0.475 alpha:1.00];
    } else if ([lbl2.text isEqualToString:@"துணைப்பாடம்"]) {
        cell.backgroundColor = [UIColor colorWithRed:0.133 green:0.639 blue:0.816 alpha:1.00];
    } else if ([lbl2.text isEqualToString:@"இலக்கணம்"]) {
        cell.backgroundColor = [UIColor colorWithRed:0.306 green:0.314 blue:0.533 alpha:1.00];
    } else{
        cell.backgroundColor = [UIColor blackColor];
    }
    
    cell.layer.cornerRadius = 5.0f;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *message = [NSString stringWithFormat:@"Item %ld tapped", (long)indexPath.row + 1];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
    NSString *pageNum = [[[self.pageObject objectForKey:@"Pages"] objectAtIndex:indexPath.row] valueForKey:@"PageNumber"];
    NSString *pdfName = [[[self.pageObject objectForKey:@"Pages"] objectAtIndex:indexPath.row] valueForKey:@"pdfName"];
    
    [self openLazyPDF:pdfName :[pageNum intValue]];
    
}

- (void)openLazyPDF:(NSString *)pdfName :(int)iPage
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
//    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pdfName ofType:@"pdf"];
    
//    NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
    
    
    
    LazyPDFDocument *document = [LazyPDFDocument withDocumentFilePath:filePath password:phrase];
    
    if (document != nil) // Must have a valid LazyPDFDocument object in order to proceed with things
    {
        LazyPDFViewController *lazyPDFViewController = [[LazyPDFViewController alloc] initWithLazyPDFDocument:document];
//        [lazyPDFViewController showDocumentPage:2];
        
        lazyPDFViewController.delegate = self; // Set the LazyPDFViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:lazyPDFViewController animated:YES];
        
#else // present in a modal view controller
        
        lazyPDFViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        lazyPDFViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:lazyPDFViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [LazyPDFDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

#pragma mark - LazyPDFViewControllerDelegate methods

- (void)dismissLazyPDFViewController:(LazyPDFViewController *)viewController
{
    // dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - ASJCollectionViewFillLayoutDelegate

- (NSInteger)numberOfItemsInSide
{
    return 4;
}

- (CGFloat)itemLength
{
    return 180.0f;
}

- (CGFloat)itemSpacing
{
    return 10.0f;
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)picClicked:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Functionality Not Available Now" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)vidClicked:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Functionality Not Available Now" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(IBAction)questionsClicked:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Functionality Not Available Now" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
