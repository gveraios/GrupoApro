//
//  DetailsViewController.m
//  GrupoApro
//
//  Created by Guillermo Vera on 7/15/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import "DetailsViewController.h"
#import "Reachability.h"


@interface DetailsViewController ()
@end

@implementation DetailsViewController
@synthesize imageViewImage,textLabel,textLabelText,imageView,polizaLabelText,polizaLabel,estatusPagoLabel,pagoEstado;




- (void)viewDidLoad
{
    [super viewDidLoad];

    UIFont* f = [UIFont fontWithName:@"Asap-Italic" size:17];
    UIFont* ff = [UIFont fontWithName:@"Asap-Italic" size:16];
    UIFont* fff = [UIFont fontWithName:@"Asap-Italic" size:16];
    UIFont* quatro = [UIFont fontWithName:@"Asap-Italic" size:19];

    
    [self.textLabel setFont:f];
    [self.polizaLabel setFont:ff];
    [self.nombreLabel setFont:fff];
    [self.desdeLabel setFont:ff];
    [self.hastaLabel setFont:ff];
    [self. statusLabel setFont:ff];
    [self.elestatus setFont:ff];
    [self.estatusPagoLabel setFont:ff];
    [self.pagoEstado setFont:quatro];
    [self.sumaAseguradaLabel setFont:ff];
    [self.pagoEstado setFont:ff];
    
    // Do any additional setup after loading the view.
    self.imageView.image =[UIImage imageNamed: [[NSUserDefaults standardUserDefaults]objectForKey:@"laimagen"]];
    self.textLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"tipoliza"];
self.textLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.polizaLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.desdeLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.hastaLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.statusLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.nombreLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.estatusPagoLabel.textColor  = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.pagoEstado.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.sumaAseguradaLabel.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];

    NSUserDefaults* defff = [NSUserDefaults standardUserDefaults];
    NSString* miConsulta = [defff objectForKey:@"miresp"];
    NSInteger miIndex = [defff integerForKey:@"myindex"];
   // NSLog(@"el index es %d y la req es %@",miIndex,miConsulta);
    NSMutableArray* cates =     [[NSUserDefaults standardUserDefaults]objectForKey:@"misCategorias"];

    
    NSString* mistringtitulo = self.textLabel.text;
    if ([self.textLabel.text isEqualToString:@"Médico"]) {
        mistringtitulo = @"Daños";
    }else if ([self.textLabel.text isEqualToString:@"Inmueble"]){
        mistringtitulo = @"Beneficios";
    }

    NSArray *listItems = [self.polizaLabelText componentsSeparatedByString:@"\t\t\t\t"];
    


    
    self.DESDELabelText = [self.DESDELabelText stringByReplacingOccurrencesOfString:@"T00:00:00" withString:@""];
    self.hastaLabelText = [self.hastaLabelText stringByReplacingOccurrencesOfString:@"T00:00:00" withString:@""];
    self.polizaLabel.text = [NSString stringWithFormat:@"Póliza :\t\t\t\t%@",listItems[0]];
    self.hastaLabel.text =  [NSString stringWithFormat:@"Fin de vigencia :\t\t%@",self.hastaLabelText];


    //2012-09-11T00:00:00
    //22066 es desde 2012-09-11 y hasta 2012-10-11
    
    //5616 desde 2013-10-28 y hasta 2014-10-28


    self.desdeLabel.text =
    
    
[NSString stringWithFormat:@"Inicio de vigencia :\t\t%@",self.DESDELabelText];

    
    self.elestatus.text = self.STATText;
    self.nombreLabel.text =[NSString stringWithFormat:@"Concepto de Póliza :  %@",
 self.NAMEText];

    if ([self.elestatus.text isEqualToString:@"Cancelada"]||[self.elestatus.text isEqualToString:@"Vencida"]) {
        self.elestatus.textColor = [UIColor redColor];
    }else{
        self.elestatus.textColor = [UIColor colorWithRed:0.035 green:0.635 blue:0.039 alpha:1]; /*#09a20a*/
    }
    [self getRecibos:nil];
    
    if ([self.textLabel.text isEqualToString:@"Vida"]) {
        self.sumaAseguradaLabel.hidden = NO;
        [self getSumaAsegurada:nil];

    }
//2012-09-11
    
    [self getPLanDocto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction)REFRESH:(id)sender {
    
    if ([self hayInternet]) {
        UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Datos refrescados exitosamente" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [al show];
        NSLog(@"refresh");
    }else{
        UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Conéctese a internet para refrescar los datos" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [al show];
        NSLog(@"refresh");
        
    }
    
}


-(void) getPLanDocto
{
    NSLog(@"entre plan");

    if ([self.textLabel.text isEqualToString:@"Médico"])
    {
        NSLog(@"Voy al medico");
        //URL del Web Service
        NSLog(@"TES ESTOY PASANDO %@",self.doctosString);
        
        NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
        //eStatus_Recibos
        NSString*string =   [NSString stringWithFormat:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>%@</PropertyIDData><PropertyTypeReadData>eDocumento_Detail</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>",self.doctosString] ;
        //Creamos la peticion
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        //Añadimos Message Lenght
        NSString *msgLength = [NSString stringWithFormat:@"%lu",
                               (unsigned long)[string length]];
        //Content type
        [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //ActionSOAP
        [req addValue:@"http://tempuri.org/ReadInfoData" forHTTPHeaderField:@"SOAPAction"];
        [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        //MetodoHTTP
        [req setHTTPMethod:@"POST"];
        //Encoding
        [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *resultsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
        
        if(error){
            NSLog(@"Error sending soap request: %@", error);
            // return [NSString stringWithFormat:@"Error sending soap request: %@", error];
        }
        
        
        NSLog(@"EL ID ES %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"idcliente"]);
        
        NSLog(@"msleght %@", msgLength);
        NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Respueta %@",respuesta);
        
        NSArray* polizas = [respuesta componentsSeparatedByString:@"&lt;NombreProd&gt;"];
        
        NSString* loqueMeInteresa = polizas[1];
        NSArray* elBueno = [loqueMeInteresa componentsSeparatedByString:@"&lt;/NombreProd&gt;"];
        NSLog(@"el arrays es: %@", elBueno);
        NSString* tipoPlan = elBueno[0];
        self.nombreLabel.text =[NSString stringWithFormat:@"Plan de Póliza :  %@",
                                tipoPlan];



        
    }
    //&lt;NombreProd&gt
}

- (IBAction)getRecibos:(id)sender
{
    //URL del Web Service
    NSLog(@"TES ESTOY PASANDO %@",self.doctosString);

    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    //eStatus_Recibos
    NSString*string =   [NSString stringWithFormat:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>%@</PropertyIDData><PropertyTypeReadData>eRecibos_Docto</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>",self.doctosString] ;
    //Creamos la peticion
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //Añadimos Message Lenght
    NSString *msgLength = [NSString stringWithFormat:@"%lu",
                           (unsigned long)[string length]];
    //Content type
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //ActionSOAP
    [req addValue:@"http://tempuri.org/ReadInfoData" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //MetodoHTTP
    [req setHTTPMethod:@"POST"];
    //Encoding
    [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *resultsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    if(error){
        NSLog(@"Error sending soap request: %@", error);
       // return [NSString stringWithFormat:@"Error sending soap request: %@", error];
    }
    
    
    NSLog(@"EL ID ES %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"idcliente"]);
    
    NSLog(@"msleght %@", msgLength);
    NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
    
    NSArray* polizas = [respuesta componentsSeparatedByString:@";Status_TXT&gt;"];
    
    NSMutableArray* lamierda = [[NSMutableArray alloc]init];
    for (int i = 0; i < polizas.count; i++) {
        NSRange range3 = [polizas[i] rangeOfString:@"&lt;"];
        NSString *newString = [polizas[i] substringWithRange:NSMakeRange(0, range3.location)];

        [lamierda addObject:newString ];
    }

    NSString*loqueQUedo = (NSString*)[lamierda lastObject];
    NSRange range = [loqueQUedo rangeOfString:@"<?xml version="];
    if(range.location != NSNotFound){
        //do something
        self.pagoEstado.text = @"Ahora no disponible";
    }else{
        self.pagoEstado.text = (NSString*)[lamierda lastObject];
    }

    
    if ( [self.pagoEstado.text isEqualToString:@"Liquidado"] || [self.pagoEstado.text isEqualToString:@"Cobrado"] || [self.pagoEstado.text isEqualToString:@"Enviado"]) {
        self.pagoEstado.textColor = [UIColor colorWithRed:0.035 green:0.635 blue:0.039 alpha:1] ;
        
    }
    else if ([self.pagoEstado.text isEqualToString:@"Cancelado"] || [self.pagoEstado.text isEqualToString:@"Pendiente"]){
        self.pagoEstado.textColor = [UIColor redColor];

    }
   
}


- (IBAction)getSumaAsegurada:(id)sender
{
    NSString* idCLiente = [[NSUserDefaults standardUserDefaults] objectForKey:@"idcliente"];
    
    //URL del Web Service
  //  NSLog(@"VOY ASEGURADO %@",self.doctosString);
    
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    //eStatus_Recibos
    NSString*string =   [NSString stringWithFormat:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>%@</PropertyIDData><PropertyTypeReadData>eDocumento_Coberturas</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_JSON</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>",self.doctosString] ;
    //Creamos la peticion
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //Añadimos Message Lenght
    NSString *msgLength = [NSString stringWithFormat:@"%lu",
                           (unsigned long)[string length]];
    //Content type
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //ActionSOAP
    [req addValue:@"http://tempuri.org/ReadInfoData" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    //MetodoHTTP
    [req setHTTPMethod:@"POST"];
    //Encoding
    [req setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *resultsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    if(error){
        NSLog(@"Error sending soap request: %@", error);
        // return [NSString stringWithFormat:@"Error sending soap request: %@", error];
    }
    NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
   // NSLog(@"El result es %@",respuesta);

    
    NSArray* polizas = [respuesta componentsSeparatedByString:@"SumaAseg:"];
    NSString* lomio = polizas[1];
    NSArray* polizas2 = [lomio componentsSeparatedByString:@"',DeducibleL:"];
    NSString* lomio2 = polizas[1];
    lomio2 = [lomio2 stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSLog(@"loans: %@", lomio2);
    
    NSRange range = [lomio2 rangeOfString:@",DeducibleL"];
    
    NSString *newString = [lomio2 substringToIndex:range.location];
    NSLog(@"%@",newString);
    
    self.sumaAseguradaLabel.text = [NSString stringWithFormat:@"Suma asegurada : \t $%@",newString];
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
