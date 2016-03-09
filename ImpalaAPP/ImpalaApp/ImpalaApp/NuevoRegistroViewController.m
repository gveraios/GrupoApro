//
//  NuevoRegistroViewController.m
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/27/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import "NuevoRegistroViewController.h"
#import "PolizasViewController.h"
#import "Reachability.h"

@interface NuevoRegistroViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *verificabutton;
@property (strong, nonatomic) IBOutlet UITableView *tabble;
@property (strong, nonatomic) IBOutlet NSArray *meses;
@property (weak, nonatomic) IBOutlet UILabel *verificalabel;
@end
int veintitres = -1;
int camposVacios = 4;

@implementation NuevoRegistroViewController
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.verificabutton.backgroundColor = [UIColor clearColor];
    self.verificalabel.textColor = [UIColor blackColor];

}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
   }

- (IBAction)registrar:(id)sender {

    if (camposVacios > 0) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error !" message:[NSString stringWithFormat: @"Olvidaste llenar algun campo."] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"todo bien parcero");
    if ([self hayInternet]) {
 
        UIAlertView* aaal = [[UIAlertView alloc]initWithTitle:@"Verificando datos" message:[NSString stringWithFormat: @"Espere por favor ..."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aaal show];
        NSString* poliza = self.campoPoliza.text;
        NSString* fechaInicio = self.campoFecha.accessibilityLabel;
        NSString* cumple = self.campoFechaNacimiento.accessibilityLabel;
        NSString* rfc = self.campoPassword2.text;
    NSString* respuesta =   [self verificaSiexisteElclienteConLaPoliza:poliza laFechadeInicio:fechaInicio laFechaDeNacimiento:cumple yElRfc:rfc];
        NSArray* resp  = [respuesta componentsSeparatedByString:@";IDCli&gt;"];
        NSLog(@"la long de la resp es %d",resp.count);
        if ([resp count]>1) {
            NSString* idd  = [resp[1] substringToIndex:5];
            NSString *newString = [[idd componentsSeparatedByCharactersInSet:
                                    [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                   componentsJoinedByString:@""];
            NSLog(@"el id bien es %@",newString);
            NSUserDefaults* DEF = [NSUserDefaults standardUserDefaults];
            [DEF setObject:newString  forKey:@"idcliente"];
            [DEF setObject:self.campoPoliza.text forKey:@"poliza"];
            [DEF synchronize];
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Bienvenido" message:[NSString stringWithFormat: @"Usuario existente"] delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            UIActivityIndicatorView * views = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            views.center = CGPointMake(self.view.center.x, self.view.center.y-120);
            [self.view addSubview:views];
            [views startAnimating];
            [alert show];

            PolizasViewController* vc = [[self
                                          storyboard]instantiateViewControllerWithIdentifier:@"polizas"];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"sesion"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vc animated:YES completion:^{
                [views stopAnimating];
            }];
          
            /**
             NSArray* idCliente = [string componentsSeparatedByString:@"DATAREL&gt;"];
             NSString* idClientes = idCliente[3];
             NSString* idFinal =
             [idClientes stringByReplacingOccurrencesOfString:@"&lt;/" withString:@""];*/
        }else{
            
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error !" message:[NSString stringWithFormat: @"Usuario no existente !\nVerifique su información"] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
           

            return;
        }
        
    }else{
        return;
    }
       }


-(NSString*)verificaSiexisteElclienteConLaPoliza:(NSString*)poliza laFechadeInicio:(NSString*) fechaDeInicio laFechaDeNacimiento:(NSString*)fechaDeNacimiento yElRfc:(NSString*)rfc{
    /** Datos prueba
     strcpy(params[0], "PRUEBAVARIOSANIOS");//número de póliza
     strcpy(params[1], "2013-10-24T00:00:00");//fecha de inicio de vigencia
     strcpy(params[2], "1974-05-23T00:00:00");//fecha de nacimiento del cliente
     strcpy(params[3], "BORV-740523-MV5");//RFC del cliente
     */
    
    NSLog(@"Me estas pasando a%@ a%@ a%@ a%@",poliza,fechaDeInicio,fechaDeNacimiento,rfc);
    NSString* inicio = [NSString stringWithFormat:@"%@",fechaDeInicio];
    NSString* cumple = [NSString stringWithFormat:@"%@",fechaDeNacimiento];
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";

    NSString* string = [ NSString stringWithFormat: @"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body><VerifyExistClient xmlns=\"http://tempuri.org/\"><oConfigData><PropertyData_Documento>%@</PropertyData_Documento><PropertyData_InicioVig>%@</PropertyData_InicioVig><PropertyData_FechaNac>%@</PropertyData_FechaNac><PropertyData_RFC>%@</PropertyData_RFC><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></VerifyExistClient></SOAP-ENV:Body></SOAP-ENV:Envelope>",poliza,inicio,cumple,rfc];

    NSLog(@"ESTE ES TU REQUEST %@",string);
     NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [string length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/VerifyExistClient" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *resultsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    if(error){
        NSLog(@"Error sending soap request: %@", error);
        return [NSString stringWithFormat:@"Error sending soap request: %@", error];
    }
    NSLog(@"%@", msgLength);
    NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
    NSLog(@"MEMO LA RESP ES %@", respuesta);

    return respuesta;


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    camposVacios = 4;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.campoPoliza.delegate = self;
    self.campoFecha.delegate = self;
    self.campoNombre.delegate = self;

    self.campoPassword2.delegate = self;
    self.campoFechaNacimiento.delegate = self;
    
    self.campoPassword2.secureTextEntry = NO;
    self.verificabutton.backgroundColor = [UIColor clearColor];
  
}
-(void)viewDidAppear:(BOOL)animated{
    self.verificalabel.textColor = [UIColor blackColor];
    self.verificabutton.backgroundColor = [UIColor clearColor];
    self.campoPoliza.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"poliza"];
    if (![self.campoPoliza.text isEqualToString:@""] || ![self.campoPoliza.text isEqualToString:NULL]) {
        camposVacios-=1;
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"sesion"]) {
        NSLog(@"sesion abierta");
       
        UIActivityIndicatorView * views = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        views.center = CGPointMake(self.view.center.x, self.view.center.y-120);
        [self.view addSubview:views];
        [views startAnimating];
        UIAlertView*al = [[UIAlertView alloc]initWithTitle:@"Cargando datos ..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
      //  [al show];
        
        PolizasViewController* vc = [[self
                                      storyboard]instantiateViewControllerWithIdentifier:@"polizas"];
        vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:^{
            [views stopAnimating];
        }];


        
        
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 23) {
      
        NSLog(@"SOY 23");
    }
    else if (textField.tag == 24) {
               NSLog(@"SOY 24");

        
    }

}
- (IBAction)loginPass:(id)sender
{
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    
    NSString* string = [ NSString stringWithFormat: @"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body><AutenticarWEB xmlns=\"http://tempuri.org/\"><oConfigData><Data_LoginWEB>mpardinas@grupoapro.com</Data_LoginWEB><Data_PasswWEB>MP32zaW</Data_PasswWEB><Data_TypePortal>ePortalInd</Data_TypePortal><Data_SerieWEB>1053</Data_SerieWEB><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></AutenticarWEB></SOAP-ENV:Body></SOAP-ENV:Envelope>"];
    
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
    
    
    
    NSArray* resp  = [respuesta componentsSeparatedByString:@"<IDUser>"];
    NSLog(@"la long de la resp es %d",resp.count);
    if ([resp count]>1)
    {
        
        NSString* idd  = [resp[1] substringToIndex:5];
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
        
        PolizasViewController* vc = [[self
                                      storyboard]instantiateViewControllerWithIdentifier:@"polizas"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"sesion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        vc.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:^{
            [views stopAnimating];
        }];
        
    }else {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error !" message:[NSString stringWithFormat: @"Usuario no existente !\nVerifique su información"] delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }

}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"TEXT");
    if (textField.tag == 23 || textField.tag == 24) {
        textField.backgroundColor = [UIColor colorWithRed:0.933 green:0.251 blue:0.212 alpha:1];
        return;
    }
    UITextField* tF = textField;
    if ([[tF text] isEqualToString:@""]||[[tF text]isEqual:nil]) {
        UIAlertView*al = [[UIAlertView alloc]initWithTitle:@"Error !" message:@"Olvidaste poner los campos en Rojo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [al show];
        tF.backgroundColor = [UIColor colorWithRed:0.933 green:0.251 blue:0.212 alpha:1];
        
    }
    else if(![[tF text] isEqualToString:@""]){
        NSLog(@"entre");
        camposVacios--;
        tF.backgroundColor = [UIColor whiteColor];
    }
   }

- (IBAction)verf:(id)sender
{
    self.verificalabel.textColor = [UIColor whiteColor];
    self.verificabutton.backgroundColor =        [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
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
@end
