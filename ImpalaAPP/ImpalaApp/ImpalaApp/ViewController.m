//
//  ViewController.m
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/26/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//
#import "ViewController.h"
#import "cliente_http.h"
#import "PolizasViewController.h"
#import "Reachability.h"
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *correo;
@property (weak, nonatomic) IBOutlet UITextField *passw;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.correo.delegate = self;
    self.passw.delegate = self;
    UIFont* f = [UIFont fontWithName:@"Asap-Italic" size:16];
    self.textView.font = f;
    self.textView.textColor = [ UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];

}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)loginPass:(id)sender
{
    
    
    
    
    if ([self hayInternet]) {
        
        if ([self.correo.text isEqualToString:@""] || [self.passw .text isEqualToString:@""]) {
            UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Olvidaste llenar algún campo" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [al show];
            return;
        }

        
        
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    
    NSString* string = [ NSString stringWithFormat: @"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body><AutenticarWEB xmlns=\"http://tempuri.org/\"><oConfigData><Data_LoginUWEB>%@</Data_LoginUWEB><Data_PasswUWEB>%@</Data_PasswUWEB><Data_TypePortal>ePortalInd</Data_TypePortal><Data_SerieUWEB>1053</Data_SerieUWEB><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></AutenticarWEB></SOAP-ENV:Body></SOAP-ENV:Envelope>",self.correo.text,self.passw.text];
    
    NSLog(@"ESTE ES TU REQUEST %@",string);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [string length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/AutenticarWEB" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *resultsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    if(error){
        NSLog(@"Error sending soap request: %@", error);
        return ;
    }
    NSLog(@"%@", msgLength);
    NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
    NSLog(@"MEMO LA RESP ES %@", respuesta);
    
    
    
    NSArray* resp  = [respuesta componentsSeparatedByString:@"&lt;DATAREL&gt;"];
    NSLog(@"la long de la resp es %d",resp.count);
        
        BOOL todobien = NO;
        if ([respuesta rangeOfString:@"Password Incorrecto"].location == NSNotFound && [respuesta rangeOfString:@"User doesn´t Exist"].location == NSNotFound) {
            NSLog(@"sub string doesnt exist");
            todobien = YES;
        }
        else {
            NSLog(@"exists");
        
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error !" message:[NSString stringWithFormat: @"Usuario o contraseña incorrectos !\nVerifique su información"] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if ([resp count]>1 && todobien)
    {
        
        NSString* idd  = [resp[1] substringToIndex:5];
        NSLog(@"el id mal es %@",idd);
        NSString *newString = [[idd componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        NSLog(@"el id bien es %@",newString);
        NSUserDefaults* DEF = [NSUserDefaults standardUserDefaults];
        [DEF setObject:newString  forKey:@"idcliente"];
        // [DEF setObject:self.campoPoliza.text forKey:@"poliza"];
        [DEF synchronize];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Bienvenido" message:[NSString stringWithFormat: @"Usuario existente"] delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        UIActivityIndicatorView * views = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        views.center = CGPointMake(self.view.center.x, self.view.center.y-120);
        [self.view addSubview:views];
        [views startAnimating];
        [alert show];
        
        self.passw.text = @"";
        PolizasViewController* vc = [[self
                                      storyboard]instantiateViewControllerWithIdentifier:@"polizas"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"sesion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:^{
            [views stopAnimating];
        }];
        
    }else {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error !" message:[NSString stringWithFormat: @"Intenta de nuevo"] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        //[alert show];
        
        return;
    }
    }else
    {return;}
    /**
     if(message contents <IDUser>){
     inicia sesion
     }
     else{
     error
     }
     
     return;
     */
    
}
-(BOOL)hayInternet{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"No se detectó conexión a internet activa" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{


}


@end
