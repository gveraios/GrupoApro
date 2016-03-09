//
//  NuevoRegistroViewController.h
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/27/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cliente_http.h"

@interface NuevoRegistroViewController : UITableViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *campoFechaNacimiento;
@property (weak, nonatomic) IBOutlet UITextField *campoPassword2;
@property (weak, nonatomic) IBOutlet UITextField *campoNombre;
@property (weak, nonatomic) IBOutlet UITextField *campoFecha;
@property (weak, nonatomic) IBOutlet UITextField *campoPoliza;
-(IBAction)textFieldReturn:(id)sender;
@end
