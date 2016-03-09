//
//  PolizasViewController.m
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/26/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import "PolizasViewController.h"
#import "Reachability.h"
@interface PolizasViewController ()


@end

@implementation PolizasViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [_delegate didClickedRefreshButton];
       self.navigationController.navigationBar.hidden = YES;
   // self.delegate = self;
	}

- (IBAction)settingsPressed:(id)sender {
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Cerrar Sesión" otherButtonTitles:@"Refrescar",@"Contacto", nil];
       [sheet showInView:self.view];
  //  [_delegate didClickedRefreshButton];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"" forKey:@"email"];
        [def setBool:NO forKey:@"sesion"];
        [def setObject:@"" forKey:@"idcliente"];
        [def synchronize];
        UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Sesión cerrada con éxito" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [al show];
    }
    
    else if (buttonIndex == 2){
        NSLog(@"MEMO SI");
        UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Quieres llamar a nuestro numero de atención?" message:@"" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Llamar ahora", nil];
        [al show];
        
    }
    
    else if(buttonIndex == 1){
        if ([self hayInternet]) {
            UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Datos refrescados exitosamente" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [al show];
            NSLog(@"refresh");
            [self.delegate didClickedRefreshButton];
        }
        
        
        
        else{
            UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Conéctese a internet para refrescar los datos" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [al show];
            NSLog(@"refresh");
        }
      
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"Memo te llamo");

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:5556666633"]];


    }
}

-(BOOL)hayInternet{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
                return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
    
    
}


@end
