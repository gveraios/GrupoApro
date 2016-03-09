//
//  MyCustomCell.h
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/26/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBadgeView.h"
#import "SKSTableViewCell.h"


@interface MyCustomCell : SKSTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nombreCelda;
@property (weak, nonatomic) IBOutlet UIImageView *imagenCelda;
@property (weak, nonatomic) IBOutlet LKBadgeView *badgeCelda;
@property (weak, nonatomic) IBOutlet UIView *colorfulView;
@property (strong, nonatomic)  NSString *desdeTEXT;

@end
