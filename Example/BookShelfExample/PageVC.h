//
//  PageVC.h
//  BookShelfExample
//
//  Created by Prav on 27/12/2016.
//  Copyright © 2016 Michał Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LazyPDFKit/LazyPDFKit.h>
#import "ASJCollectionViewFillLayout.h"

@interface PageVC : UIViewController <LazyPDFViewControllerDelegate>

@property (nonatomic ) int noOfitems;
@property (nonatomic, strong) NSDictionary *pageObject;
@property (nonatomic, strong) IBOutlet UILabel *titleName;

@end
