//
//  DetailsViewController.h
//  GrupoApro
//
//  Created by Guillermo Vera on 7/15/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic)  NSString *textLabelText;
@property (weak, nonatomic) UIImage *imageViewImage;
@property (weak, nonatomic) IBOutlet UILabel *elestatus;
@property (weak, nonatomic) IBOutlet UILabel *sumaAseguradaLabel;

@property (weak, nonatomic) IBOutlet UILabel *polizaLabel;
@property (weak, nonatomic)  NSString *polizaLabelText;
@property (weak, nonatomic)  NSString *DESDELabelText;

@property (strong, nonatomic)  NSString *doctosString;
@property (weak, nonatomic) IBOutlet UILabel *estatusPagoLabel;

@property (weak, nonatomic) IBOutlet UITextView *pagoEstado;

- (IBAction)back:(id)sender;
- (IBAction)REFRESH:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *hastaLabel;
@property (weak, nonatomic)  NSString *hastaLabelText;

@property (weak, nonatomic)  NSString *STATText;
@property (weak, nonatomic)  NSString *NAMEText;



@property (weak, nonatomic) IBOutlet UILabel *desdeLabel;
@property (weak, nonatomic) IBOutlet UITextView *nombreLabel;

@end
