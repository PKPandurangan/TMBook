//
//  BSViewController.m
//  BookShelfExample
//
//  Created by Michał Zaborowski on 13.06.2014.
//  Copyright (c) 2014 Michał Zaborowski. All rights reserved.
//

#import "BSViewController.h"
#import "MZBookShelfCollectionViewLayout.h"
#import "PageVC.h"

@interface BSViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MZBookshelfCollectionViewLayoutDelegate>

@end

@implementation BSViewController

@synthesize pagesArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pagesArray = [[NSMutableArray alloc] init];
    // Load sample data into the array
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Pages" ofType:@"plist"];
    [self.pagesArray addObjectsFromArray:[NSArray arrayWithContentsOfFile:filePath]];
    

    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	
    MZBookshelfCollectionViewLayout *layout = (id)self.collectionView.collectionViewLayout;
    [layout registerNib:[UINib nibWithNibName:@"MZBookShelfDecorationView" bundle:nil] forDecorationViewOfKind:MZBookshelfCollectionViewLayoutDecorationViewKind];
    
    
}

- (CGFloat)widthForSection:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    
    CGFloat availableWidth = layout.collectionViewContentSize.width - (layout.sectionInset.left + layout.sectionInset.right);
    int itemsAcross = floorf((availableWidth + layout.minimumInteritemSpacing) / (layout.itemSize.width + layout.minimumInteritemSpacing));
    int itemCount = (int)[layout.collectionView numberOfItemsInSection:section];
    int rows = ceilf(itemCount/(float)itemsAcross);
    CGFloat itemsInRow = ceilf((double)itemCount /rows);
    
    return itemsInRow * (layout.itemSize.width + layout.minimumInteritemSpacing) + (layout.sectionInset.left + layout.sectionInset.right);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(MZBookshelfCollectionViewLayout *)collectionViewLayout referenceSizeForDecorationViewForRow:(NSInteger)row inSection:(NSInteger)section
{
//    if (section == 0) {
        if (collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            return CGSizeMake([self widthForSection:section], 113);
        } else {
            return CGSizeMake(collectionViewLayout.collectionViewContentSize.width, 113);
        }
        
//    }
    return CGSizeZero;
}

- (UIOffset)collectionView:(UICollectionView *)collectionView layout:(MZBookshelfCollectionViewLayout *)collectionViewLayout decorationViewAdjustmentForRow:(NSInteger)row inSection:(NSInteger)section
{
    return UIOffsetMake(8, -30);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.pagesArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.pagesArray objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    NSString *str = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section + 6,(long)indexPath.row+1];
    NSString *str = [[[self.pagesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"image"];
    UIImage *imgNamed = [UIImage imageNamed:str];
    UIImageView *finImg = (UIImageView *)[cell.contentView viewWithTag:5];
    finImg.image = imgNamed;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
//    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
//    NSLog(@"cell..%ld",indexPath.row);
        
    PageVC *page = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PageVC"];
    page.pageObject = [[self.pagesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self presentViewController:page animated:YES completion:nil];
    
}

//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
//    NSLog(@"cell..%ld",indexPath.row);
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
//    return reusableView;
//}





@end
