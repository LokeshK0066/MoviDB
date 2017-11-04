//
//  DetailsMovieCellClassVC.h
//  MovieDBProject
//
//  Created by iOS Dev on 11/3/17.
//  Copyright © 2017 Snsepro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsMovieCellClassVC : UICollectionViewCell

//Grid Class

@property (weak, nonatomic) IBOutlet UIImageView *imgMmovie;
@property (weak, nonatomic) IBOutlet UILabel *lblMovieName;


//Details View
@property (weak, nonatomic) IBOutlet UILabel *lblMovieOverview;
@property (weak, nonatomic) IBOutlet UILabel *lblRelasedate;
@property (weak, nonatomic) IBOutlet UILabel *lblMovieRates;


@end
