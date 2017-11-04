//
//  GridMovieViewClassVC.h
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridMovieViewClassVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

- (IBAction)BtnSearch:(id)sender;
- (IBAction)BtnFilter:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy, nonatomic) NSString *imagesBaseUrlString;
@property (strong, nonatomic) NSArray *moviesArray;
@property(nonatomic,strong)UIRefreshControl *refreshControl;


@end
