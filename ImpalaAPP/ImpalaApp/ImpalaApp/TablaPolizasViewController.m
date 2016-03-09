//
//  TablaPolizasViewController.m
//  ImpalaApp
//
//  Created by Guillermo Vera on 3/27/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#import "TablaPolizasViewController.h"
#import "DetailsViewController.h"
#import "PolizasViewController.h"
#define kTypeVida "Vida"
#define kTypeMedico "Beneficios"
#define kTypeAuto "Vehiculos"
#define kTypeInmuele "Daños"
//#import "http_client.h"


@interface TablaPolizasViewController ()<SKSTableViewDelegate,PolizaDelegate>
@property(nonatomic,strong)NSArray* imagesName;
@property(nonatomic,strong)NSArray* categorias;
@property(nonatomic,strong)NSArray* nombres;
@property(nonatomic,strong)NSMutableArray* doctos;


@property(nonatomic,strong)UITableViewCell* miCelda;
@property(nonatomic,strong)MyCustomCell* miCeldaImagen;


@property(nonatomic,strong)NSMutableArray* contenidoAuto;
@property(nonatomic,strong)NSMutableArray* contenidoMedico;
@property(nonatomic,strong)NSMutableArray* contenidoVida;
@property(nonatomic,strong)NSMutableArray* contenidoInmueble;


//aqui guardo los desdes correctamente
@property(nonatomic,strong)NSMutableArray* contenidoAuto2;
@property(nonatomic,strong)NSMutableArray* contenidoMedico2;
@property(nonatomic,strong)NSMutableArray* contenidoVida2;
@property(nonatomic,strong)NSMutableArray* contenidoInmueble2;

//aqui guardo los status correctamente
@property(nonatomic,strong)NSMutableArray* contenidoAuto3;
@property(nonatomic,strong)NSMutableArray* contenidoMedico3;
@property(nonatomic,strong)NSMutableArray* contenidoVida3;
@property(nonatomic,strong)NSMutableArray* contenidoInmueble3;

//aqui guardo los propietarios correctamente
@property(nonatomic,strong)NSMutableArray* contenidoAuto4;
@property(nonatomic,strong)NSMutableArray* contenidoMedico4;
@property(nonatomic,strong)NSMutableArray* contenidoVida4;
@property(nonatomic,strong)NSMutableArray* contenidoInmueble4;
//Aqui guardo los IDDoctos
@property(nonatomic,strong)NSMutableArray* contenidoAuto5;
@property(nonatomic,strong)NSMutableArray* contenidoMedico5;
@property(nonatomic,strong)NSMutableArray* contenidoVida5;
@property(nonatomic,strong)NSMutableArray* contenidoInmueble5;


@property(nonatomic,strong)NSMutableArray* contenidoDesdes;
@property(nonatomic,strong)PolizasViewController* poliza;


@property(nonatomic,strong) NSMutableArray *_objects;
@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) UITableViewCell *LACELDA;

@end

@implementation TablaPolizasViewController
@synthesize poliza;



-(NSString*)resultadoDelaConsultaWebConElid:(NSString*)idCLiente{
    //URL del Web Service
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    //eStatus_Recibos
    NSString*string =   [NSString stringWithFormat:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>%@</PropertyIDData><PropertyTypeReadData>eDocumentos_Cliente</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>",idCLiente] ;
    //Creamos la peticion
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //Añadimos Message Lenght
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [string length]];
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
        return [NSString stringWithFormat:@"Error sending soap request: %@", error];
    }
    

    NSLog(@"EL ID ES %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"idcliente"]);

    NSLog(@"msleght %@", msgLength);
    NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
//NSLog(@"la respuesta ES %@",respuesta);
    
    //aqui guardi la respueta para buscar la mielda en la pantalla dos
    NSUserDefaults* deff = [NSUserDefaults standardUserDefaults];
    [deff setObject:respuesta forKey:@"miresp"];
    [deff synchronize];
    
    return respuesta;
}



-(void)logout
{
    NSLog(@"voy a deslogear");
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"" forKey:@"email"];
    [def setBool:NO forKey:@"sesion"];
    [def setObject:@"" forKey:@"idcliente"];
    [def synchronize];
    UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Sesión caducada, cerrando sesión ahora." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [al show];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(NSString*)resultadoDelaConsultaWebConElid2:(NSString*)idCLiente{
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    //    APRO2014gpo
    //Gpo#2014#Apro
    
    //eStatus_Recibos
    
    NSString*string =   [NSString stringWithFormat:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>%@</PropertyIDData><PropertyTypeReadData>eStatus_Recibos</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>",idCLiente] ;
    
    
    
    
    //NSLog(@"La consulta es : %@",string);
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [string length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/ReadInfoData" forHTTPHeaderField:@"SOAPAction"];
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
    
    
    NSLog(@"EL ID ES %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"idcliente"]);
    
    NSLog(@"msleght %@", msgLength);
    NSString* respuesta = [[NSString alloc] initWithData:resultsData encoding:NSUTF8StringEncoding];
    //NSLog(@"la respuesta ES %@",respuesta);
    
    //aqui guardi la respueta para buscar la mielda en la pantalla dos
    NSUserDefaults* deff = [NSUserDefaults standardUserDefaults];
    [deff setObject:respuesta forKey:@"miresp"];
    [deff synchronize];
    
    return respuesta;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.LACELDA = [[UITableViewCell alloc]init];
    self.contenidoAuto = [[NSMutableArray alloc]init];
    self.contenidoInmueble = [[NSMutableArray alloc]init];
    self.contenidoMedico = [[NSMutableArray alloc]init];
    self.contenidoVida = [[NSMutableArray alloc]init];
    
    self.contenidoAuto2 = [[NSMutableArray alloc]init];
    self.contenidoInmueble2 = [[NSMutableArray alloc]init];
    self.contenidoMedico2 = [[NSMutableArray alloc]init];
    self.contenidoVida2 = [[NSMutableArray alloc]init];

    self.contenidoAuto3 = [[NSMutableArray alloc]init];
    self.contenidoInmueble3 = [[NSMutableArray alloc]init];
    self.contenidoMedico3 = [[NSMutableArray alloc]init];
    self.contenidoVida3 = [[NSMutableArray alloc]init];

    self.contenidoAuto4 = [[NSMutableArray alloc]init];
    self.contenidoInmueble4 = [[NSMutableArray alloc]init];
    self.contenidoMedico4 = [[NSMutableArray alloc]init];
    self.contenidoVida4 = [[NSMutableArray alloc]init];

    self.contenidoAuto5 = [[NSMutableArray alloc]init];
    self.contenidoInmueble5 = [[NSMutableArray alloc]init];
    self.contenidoMedico5 = [[NSMutableArray alloc]init];
    self.contenidoVida5 = [[NSMutableArray alloc]init];

	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;
     
     UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
     self.navigationItem.rightBarButtonItem = addButton;*/

    self.imagesName = @[@"carro.png",@"vida.png",@"salud.png",@"casa.png",@""];
    self.nombres = @[@"Vehículos",@"Médico",@"Vida",@"Inmueble",@""];
    
    self.tableViewss.SKSTableViewDelegate = self;
        // In order to expand just one cell at a time. If you set this value YES, when you expand an cell, the already-expanded cell is collapsed automatically.
    self.tableViewss.shouldExpandOnlyOneCell = YES;
    // Do any additional setup after loading the view.
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSString* login = [def objectForKey:@"email"];

    NSString* id_c = [def objectForKey:@"idcliente"];
    NSLog(@"%@ %@ ",login,id_c);
   NSString* result = [self resultadoDelaConsultaWebConElid:id_c];
    
    NSLog(@"LA RESPUESTA ES %@",result);
//    NSString* result2 = [self resultadoDelaConsultaWebConElid2:id_c];
   // NSLog(@"Memo el id %@",result2);

    NSArray*categorias = [result componentsSeparatedByString:@";RamosAbreviacion&gt;"];
    NSArray* hastacuando = [result componentsSeparatedByString:@";FHasta&gt;"];
    NSArray* polizas = [result componentsSeparatedByString:@";Documento&gt;"];
    NSArray* desdes = [result componentsSeparatedByString:@"&lt;FDesde&gt;"];
    NSArray*doctos = [result componentsSeparatedByString:@"&lt;IDDocto&gt;"];
    
    NSMutableArray* categoriass = [[NSMutableArray alloc]init];
    NSMutableArray* fechas = [[NSMutableArray alloc]init];
    NSMutableArray* polizass = [[NSMutableArray  alloc]init];
    NSMutableArray *desdess = [[NSMutableArray alloc]init];
    NSMutableArray *doctoss = [[NSMutableArray alloc]init];

    
    NSMutableArray *nombress = [[NSMutableArray alloc]init];
    NSMutableArray *statuss = [[NSMutableArray alloc]init];
    
  
    NSLog(@"LOS ARREGLOS QUEDARON COMOmemo %@",desdess);

    
    
    NSArray* nombreses = [result componentsSeparatedByString:@"&lt;Concepto&gt;"];
    NSArray *statuses = [result componentsSeparatedByString:@"&lt;Status_TXT&gt;"];
    
    
    

    
    if (categorias.count > 1) {
        for (int i = 0; i < categorias.count; i++) {
            NSRange range = [categorias[i] rangeOfString:@"&lt;"];
            NSRange range2 = [hastacuando[i] rangeOfString:@"&lt;"];
            NSRange range3 = [polizas[i] rangeOfString:@"&lt;"];


            NSString *newString = [categorias[i] substringWithRange:NSMakeRange(0, range.location)];
            NSString *newString2 = [hastacuando[i] substringWithRange:NSMakeRange(0, range2.location)];
            NSString *newString3 = [polizas[i] substringWithRange:NSMakeRange(0, range3.location)];
           
            
            NSRange range4 = [desdes[i] rangeOfString:@"&lt;"];
            NSString *newString4 = [desdes[i] substringWithRange:NSMakeRange(0, range4.location)];
            [desdess addObject:newString4];
            
            NSRange range5 = [nombreses[i] rangeOfString:@"&lt;"];
            NSString *newString5 = [nombreses[i] substringWithRange:NSMakeRange(0, range5.location)];
            [nombress addObject:newString5];

            
            NSRange range6 = [statuses[i] rangeOfString:@"&lt;"];
            NSString *newString6 = [statuses[i] substringWithRange:NSMakeRange(0, range6.location)];
            [statuss addObject:newString6];
            
            
            NSRange range7 = [doctos[i] rangeOfString:@"&lt;"];
            NSString *newString7 = [doctos[i] substringWithRange:NSMakeRange(0, range7.location)];
            [doctoss addObject:newString7];

            [categoriass addObject:newString];
            [fechas addObject:newString2];
            [polizass addObject:newString3];
        }
    }
    
    
    [[NSUserDefaults standardUserDefaults]setObject:categoriass forKey:@"misCategorias"];
   // [[NSUserDefaults standardUserDefaults]setObject:doctoss forKey:@"misDoctos"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    for (int i = 0; i < categoriass.count; i++) {
        NSString* tipo = categoriass[i];
        NSString*fecha;
        NSString* polizza;
        fecha = fechas[i];
        polizza = polizass[i];
        
        NSString* desde = [desdess objectAtIndex:i];
        NSString* stat = [nombress objectAtIndex:i];
        NSString* nam = [statuss objectAtIndex:i];
        NSString* docto  = [doctoss objectAtIndex:i];
        //NSLog(@"el desde es y el hasta es %@ %@",desde,fecha);
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-DD"];
        NSString * miString = [fecha stringByReplacingOccurrencesOfString:@"T00:00:00" withString:@""];
        NSDate * laFecha = [dateFormater dateFromString:miString];
        NSDate * fechaRestringida = [dateFormater dateFromString:@"2014-01-15"];
        NSComparisonResult result = [laFecha compare:fechaRestringida];
        
    
      //  NSLog(@"El resultado es %ld",result);
        
        NSString* lasdos = [NSString stringWithFormat:@"%@\t\t%@",polizza,fecha];
        if ([tipo isEqualToString:@kTypeAuto] && result == 1 ) {
            [self.contenidoAuto addObject:lasdos];
            [self.contenidoAuto2 addObject:desde];
            [self.contenidoAuto3 addObject:nam];
            [self.contenidoAuto4 addObject:stat];
            [self.contenidoAuto5 addObject:docto];

        }else if ([tipo isEqualToString:@kTypeVida]&& result == 1){
            [self.contenidoVida addObject:lasdos];
            [self.contenidoVida2 addObject:desde];
            [self.contenidoVida3 addObject:nam];
            [self.contenidoVida4 addObject:stat];
            [self.contenidoVida5 addObject:docto];
            

        }else if ([tipo isEqualToString:@kTypeMedico]&& result == 1){
            [self.contenidoMedico addObject:lasdos];
            [self.contenidoMedico2 addObject:desde];
            [self.contenidoMedico3 addObject:nam];
            [self.contenidoMedico4 addObject:stat];
            [self.contenidoMedico5 addObject:docto];


        }else
            if ( [tipo isEqualToString:@kTypeInmuele] && result == 1 ) {
            [self.contenidoInmueble addObject:lasdos];
            [self.contenidoInmueble2 addObject:desde];
            [self.contenidoInmueble3 addObject:nam];
            [self.contenidoInmueble4 addObject:stat];
            [self.contenidoInmueble5 addObject:docto];
                
              
            

        }
    }
    
    NSLog(@"Todo lo de inmueb antes didload es %@ %@ %@ %@ %@",self.contenidoInmueble,self.contenidoInmueble2,self.contenidoInmueble3,self.contenidoInmueble4,self.contenidoInmueble5);

    [self eliminaLosNoDisponiblesDelArreglo:1];
    [self eliminaLosNoDisponiblesDelArreglo:2];
    [self eliminaLosNoDisponiblesDelArreglo:3];
   // [self eliminaLosNoDisponiblesDelArreglo:4];
    
    
    NSLog(@"Todo lo de inmueb es al final de eliminar %@ %@ %@ %@ %@",self.contenidoInmueble,self.contenidoInmueble2,self.contenidoInmueble3,self.contenidoInmueble4,self.contenidoInmueble5);



    self.poliza = [self.storyboard instantiateViewControllerWithIdentifier:@"poliza"];
    self.poliza.delegate = self;
    NSLog(@"LA POLIZADELE ES %@ Y SU DELE ES %@",self.poliza,self.poliza.delegate);
    
    //900 sec = 15 min
    [self performSelector:@selector(logout) withObject:self afterDelay:600];

}

-(void)didClickedRefreshButton
{
   
    NSLog(@"A refrescarMEMOMO");
    
    UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"Datos refrescados exitosamente" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [al show];
    [[self tableViewss]reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"memo");
    BOOL hagoSegue = NO;
    UITableViewCell* cells = [tableView cellForRowAtIndexPath:indexPath];
    self.miCelda = cells;
    if ([self.miCelda isKindOfClass:[MyCustomCell class]]) {
        self.miCeldaImagen = (MyCustomCell*)self.miCelda;
        NSLog(@"LA ESA MADRE ES %@ ",self.miCeldaImagen.nombreCelda.text);
                  [[NSUserDefaults standardUserDefaults]setObject:self.miCeldaImagen.nombreCelda.text forKey:@"tipoliza"];
        self.imagesName = @[@"carro.png",@"vida.png",@"salud.png",@"casa.png",@""];
        NSString* tipoImagen = @"";
        if ([self.miCeldaImagen.nombreCelda.text isEqualToString:@"Vehículos"]) tipoImagen = @"carro.png";
     else   if ([self.miCeldaImagen.nombreCelda.text isEqualToString:@"Vida"]) tipoImagen = @"salud.png";
else        if ([self.miCeldaImagen.nombreCelda.text isEqualToString:@"Inmueble"]) tipoImagen = @"casa.png";
    else    if ([self.miCeldaImagen.nombreCelda.text isEqualToString:@"Médico"]) tipoImagen = @"vida.png";

            [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:tipoImagen forKey:@"laimagen"];
            NSLog(@"HA QUEDAO %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"tipoliza"]);
        

        return;
    }
    NSString* myStrg = cells.textLabel.text;
    NSMutableArray* excluded = (NSMutableArray*)@[@"No. Póliza\t\t\tDías Restantes",@"Auto",@"Médico",@"Vida",@"Inmueble"];
    for (NSString* s in excluded) {
        if ([self Contains:s on:myStrg] ||[self Contains:@"Póliza" on:myStrg] ) {
            NSLog(@"NO SEGUE");
            hagoSegue = NO;
        }
        else {
            NSLog(@"SI SEGUE");
            hagoSegue = YES;
        }
        

    }
    if (hagoSegue) {
        [self performSegueWithIdentifier:@"moreinfo" sender:nil];
    }
}

-(int) regresameElIndicedeLacadena:(NSString*)cad enElArreglo:(NSArray*)elArreglo
{
    int index = 0;
    for (NSString* s in elArreglo) {
        if ([s isEqualToString:cad]) {
            return index;
        }
        index++;
    }
    return -1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"moreinfo"]) {
        DetailsViewController* vc = [segue destinationViewController];
        NSLog(@"el texto poliza es %@",self.miCelda.textLabel.text);
        NSString* myPoliza = self.miCelda.textLabel.text;
        MyCustomCell* cell = [self miCeldaImagen];
        vc.imageViewImage = cell.imagenCelda.image;
        vc.textLabelText = cell.nombreCelda.text;
        
        
        
        NSLog(@"Lo que me pides es %@  y %@",self.miCeldaImagen.imagenCelda.image,self.miCeldaImagen.nombreCelda.text);
        vc.polizaLabelText = self.miCelda.textLabel.text;
        vc.DESDELabelText = self.miCelda.accessibilityHint;
        vc.hastaLabelText = self.miCelda.accessibilityLabel;
        
        vc.STATText = self.miCelda.accessibilityIdentifier;
        vc.NAMEText =self.miCelda.accessibilityLanguage;
        vc.doctosString = self.miCelda.accessibilityValue;
        
        //Vehiculos
        //Medico
        //Vida
        //Inmueble
        int indexx = -2;
        NSLog(@"ES MEMO ES %@", cell.nombreCelda.text);
        NSString* tipoliza = [[NSUserDefaults standardUserDefaults]objectForKey:@"tipoliza"];
        if ([ tipoliza isEqualToString:@"Vehículos"]) {
            //memo
            NSLog(@"LO QUE BUSCAS ES %@ Y EL LENGTH ES %lu",myPoliza,(unsigned long)self.contenidoAuto.count);
        indexx =    [self regresameElIndicedeLacadena:myPoliza enElArreglo:self.contenidoAuto
                     ];
        }else if([ tipoliza isEqualToString:@"Médico"]){
         //memo
            NSLog(@"LO QUE BUSCAS ES %@ Y EL LENGTH ES %lu",myPoliza,(unsigned long)self.contenidoMedico.count);
           indexx = [self regresameElIndicedeLacadena:myPoliza enElArreglo:self.contenidoMedico];
        }
    else if([ tipoliza isEqualToString:@"Vida"]){
        NSLog(@"LO QUE BUSCAS ES %@ Y EL LENGTH ES %lu",myPoliza,(unsigned long)self.contenidoVida.count);
        indexx =        [self regresameElIndicedeLacadena:myPoliza enElArreglo:self.contenidoVida];
        
    }    else if([ tipoliza isEqualToString:@"Inmueble"]){
        NSLog(@"LO QUE BUSCAS ES %@ Y EL LENGTH ES %lu",myPoliza,(unsigned long)self.contenidoInmueble.count);
       indexx = [self regresameElIndicedeLacadena:myPoliza enElArreglo:self.contenidoInmueble];
    }
        
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setInteger:indexx  forKey:@"myindex"];
        [def synchronize];
    }
}

-(BOOL)Contains:(NSString *)StrSearchTerm on:(NSString *)StrText
{
    return [StrText rangeOfString:StrSearchTerm
                          options:NSCaseInsensitiveSearch].location != NSNotFound;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
   

    NSLog(@"EL INDEX ESTA MIELDA ES SECCION %ld ROW %ld SUBROW %ld ",(long)indexPath.section,(long)indexPath.row,(long)indexPath.subRow);

    if (indexPath.row == 0){
        
        return self.contenidoAuto.count+1;
    }

    else if (indexPath.row == 1){ return self.contenidoMedico.count+1;}
    else if (indexPath.row == 2) {return self.contenidoVida.count+1;}
        else if (indexPath.row == 3) {return self.contenidoInmueble.count+1;}
else {
    return 0;
}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    MyCustomCell *cell = [self.tableViewss dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row == 4) {
        cell.hidden = YES;
        return cell;
    }
    
    UIFont* f = [UIFont fontWithName:@"Asap-Italic" size:17];
    [cell.nombreCelda setFont:f];
    cell.imagenCelda.image = [UIImage imageNamed: self.imagesName[indexPath.row]];
    cell.nombreCelda.text =  self.nombres[indexPath.row];
    cell.isExpandable = YES;
    
    int numberOfSubRows = 0;
    if (indexPath.row == 0) numberOfSubRows = self.contenidoAuto.count;
    else if (indexPath.row == 1) numberOfSubRows = self.contenidoMedico.count;
    else if (indexPath.row == 2) numberOfSubRows = self.contenidoVida.count;
    else if (indexPath.row == 3)
        numberOfSubRows =        self.contenidoInmueble.count-1;

    NSString* subRows = [NSString stringWithFormat:@"%d",numberOfSubRows];
    cell.badgeCelda.text = subRows;
    [cell.badgeCelda setFont:f];
    cell.backgroundColor =[UIColor colorWithRed:0.945 green:0.945 blue:0.949 alpha:1];
    cell.nombreCelda.textColor = [UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    
    
    if (cell == nil) {
        cell = (MyCustomCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
	// Configure the cell.
    
    return cell;
    

}

-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Estoy en subrowws");
    if (indexPath.row == 0) {
        return 50.0;
    }else{
        return 40.0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MiniCell";
    
    UITableViewCell *cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSLog(@"el indexpatsubrrow es %ld",(long)indexPath.subRow);
    if (indexPath.subRow == 1) {

        cell.textLabel.text = @"No. Póliza\t\t\tDías Restantes";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentLeft;

              return cell;
    }
    
    
    if (indexPath.row == 3 && indexPath.subRow == 2) {
        if (self.contenidoInmueble5.count > 1) {
            cell.hidden = YES;
            return cell;
        }
    }

    NSString* cont = @"";
    NSString* dsd = @"";
    NSString* stat = @"";
    NSString* namm = @"";
    NSString* doc = @"";

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) cont = self.contenidoAuto[indexPath.subRow-2];
    else if (indexPath.row == 1) cont = self.contenidoMedico[indexPath.subRow-2];
    else if (indexPath.row == 2) cont = self.contenidoVida[indexPath.subRow-2];
    else if (indexPath.row == 3) cont = self.contenidoInmueble[indexPath.subRow-2];

    if (indexPath.row == 0) dsd = self.contenidoAuto2[indexPath.subRow-2];
    else if (indexPath.row == 1) dsd = self.contenidoMedico2[indexPath.subRow-2];
    else if (indexPath.row == 2) dsd = self.contenidoVida2[indexPath.subRow-2];
    else if (indexPath.row == 3) dsd = self.contenidoInmueble2[indexPath.subRow-2];

    if (indexPath.row == 0) namm = self.contenidoAuto3[indexPath.subRow-2];
    else if (indexPath.row == 1) namm = self.contenidoMedico3[indexPath.subRow-2];
    else if (indexPath.row == 2) namm = self.contenidoVida3[indexPath.subRow-2];
    else if (indexPath.row == 3) namm = self.contenidoInmueble3[indexPath.subRow-2];

    if (indexPath.row == 0) stat = self.contenidoAuto4[indexPath.subRow-2];
    else if (indexPath.row == 1) stat = self.contenidoMedico4[indexPath.subRow-2];
    else if (indexPath.row == 2) stat = self.contenidoVida4[indexPath.subRow-2];
    else if (indexPath.row == 3) stat = self.contenidoInmueble4[indexPath.subRow-2];
    
    if (indexPath.row == 0) doc = self.contenidoAuto5 [indexPath.subRow-2];
    else if (indexPath.row == 1) doc = self.contenidoMedico5[indexPath.subRow-2];
    else if (indexPath.row == 2) doc = self.contenidoVida5[indexPath.subRow-2];
    else if (indexPath.row == 3) doc = self.contenidoInmueble5[indexPath.subRow-2];
    
    NSLog(@"EL DOC AHORA ES %@",doc);
    cell.textLabel.text = cont;
    cell.accessibilityHint = dsd;
    cell.accessibilityIdentifier = namm;
    cell.accessibilityLanguage = stat;
    cell.accessibilityValue = doc;
    
    NSArray *listItems = [cont componentsSeparatedByString:@"\t\t"];
    NSString* polizaHasta  = listItems[1];
    cell.accessibilityLabel = polizaHasta;

    polizaHasta = [polizaHasta stringByReplacingOccurrencesOfString:@"T00:00:00" withString:@""];
    

    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *Futuredate = [dateFormatter dateFromString:polizaHasta];

    NSLog(@"Hoy es %@ y la fecha de venc es %@",today,Futuredate);
    NSLog(@"la diferencia es de %d",[self daysBetweenDate:today andDate:Futuredate]);
    
    NSString* losDias = @"";
    int diasValue = [self daysBetweenDate:today andDate:Futuredate];
    if (diasValue <= 0) {
                losDias = @"0 Días";
     //  cell.hidden = YES;
     //   MyCustomCell* cell = [tableView cellForRowAtIndexPath:indexPath];
       // NSInteger elNumActual  = [cell.badgeCelda.text integerValue];
        //elNumActual--;
        //cell.badgeCelda.text = [NSString stringWithFormat:@"%d",elNumActual];

        //cell.tag = 101;
        NSLog(@"ahi te va un 101");
        self.LACELDA = cell;
     //   [tableView setRowHeight:0.0];
        
    }else{
        losDias = [NSString stringWithFormat:@"%d Días",diasValue];
       // [tableView setRowHeight:40.0];

    }
    NSString* final = [NSString stringWithFormat:@"%@\t\t\t\t%@",listItems[0],losDias];
    cell.textLabel.text = final;
    
    if (indexPath.row == 0) {
        NSLog(@"La poliza de este dude es %@",stat);
        
        NSString* finall = [NSString stringWithFormat:@"%@\t\t\t\t%@\n%@",listItems[0],losDias,stat];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = finall;
        return cell;

        
    }
    
    if (indexPath.row == 1) {
        NSString*needle = [self dameElTitulardeldoc:doc];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = [NSString stringWithFormat:@"%@\nAsegurado: %@",final,needle];
    }
    

    cell.backgroundColor =[ UIColor colorWithRed:0.106 green:0.267 blue:0.498 alpha:1];
    self.LACELDA = cell;
    return cell;
}



-(void)eliminaLosNoDisponiblesDelArreglo:(int)categoarreglo
{


    NSString* cont = @"";

    

    NSMutableArray* elAregloContenido2 = [[NSMutableArray alloc]init];

    
    if (categoarreglo == 1){

        elAregloContenido2 = self.contenidoAuto;
    }else if(categoarreglo == 2){

        elAregloContenido2 = self.contenidoMedico;

    }else if(categoarreglo == 3){

        elAregloContenido2 = self.contenidoVida;

    }else if(categoarreglo == 4){

        elAregloContenido2 = self.contenidoInmueble;

    }
    for (int i = 0; i < elAregloContenido2.count; i++) {
    cont = elAregloContenido2[i];
    NSArray *listItems = [cont componentsSeparatedByString:@"\t\t"];
    NSString* polizaHasta  = listItems[1];
    polizaHasta = [polizaHasta stringByReplacingOccurrencesOfString:@"T00:00:00" withString:@""];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *Futuredate = [dateFormatter dateFromString:polizaHasta];
    //    NSLog(@"Memo este es el contenido del arreglo1 %@",elAregloContenido1);
     //   NSLog(@"Memo este es el contenido del arreglo2 %@",elAregloContenido2);
       // NSLog(@"Hoy es %@ y la fecha de venc es %@",today,Futuredate);
        //NSLog(@"la diferencia es memo %d",[self daysBetweenDate:today andDate:Futuredate]);
    
    int diasValue = [self daysBetweenDate:today andDate:Futuredate];
    if (diasValue < 1) {

        
        if (categoarreglo == 1) {
            [self.contenidoAuto removeObjectAtIndex:i];
            [self.contenidoAuto2 removeObjectAtIndex:i];
            [self.contenidoAuto3 removeObjectAtIndex:i];
            [self.contenidoAuto4 removeObjectAtIndex:i];
            [self.contenidoAuto5 removeObjectAtIndex:i];
            i=-1;
        }else if (categoarreglo == 2){
            [self.contenidoMedico removeObjectAtIndex:i];
            [self.contenidoMedico2 removeObjectAtIndex:i];
            [self.contenidoMedico3 removeObjectAtIndex:i];
            [self.contenidoMedico4 removeObjectAtIndex:i];
            [self.contenidoMedico5 removeObjectAtIndex:i];
            i=-1;
        }else if (categoarreglo == 3){
            [self.contenidoVida removeObjectAtIndex:i];
            [self.contenidoVida2 removeObjectAtIndex:i];
            [self.contenidoVida3 removeObjectAtIndex:i];
            [self.contenidoVida4 removeObjectAtIndex:i];
            [self.contenidoVida5 removeObjectAtIndex:i];
            i=-1;
        }else if (categoarreglo == 4){
            NSLog(@"Soy 4 y voy a borrar un pal de puelcos porque dia es %d",diasValue);
            NSLog(@"Todo lo de inmueb es %@ %@ %@ %@ %@",self.contenidoInmueble,self.contenidoInmueble2,self.contenidoInmueble3,self.contenidoInmueble4,self.contenidoInmueble5);

            [self.contenidoInmueble removeObjectAtIndex:i];
            [self.contenidoInmueble2 removeObjectAtIndex:i];
            [self.contenidoInmueble3 removeObjectAtIndex:i];
            [self.contenidoInmueble4 removeObjectAtIndex:i];
            [self.contenidoInmueble5 removeObjectAtIndex:i];
            i=-1;
        }
    

    }
    
    }
   }



-(NSString*)dameElTitulardeldoc:(NSString*)elDocto
{
    NSString* url = @"https://www.sicasonline.com/SICASOnline/WS_SICASOnline.asmx";
    //eStatus_Recibos
    NSString*string =   [NSString stringWithFormat:@"<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>%@</PropertyIDData><PropertyTypeReadData>eDocumento_Detail</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_JSON</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>APRO2014gpo</UserName><Password>Gpo#2014#Apro</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>",elDocto] ;
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
   // NSLog(@"LOS MEDICOS SOMN %@",respuesta);

    
    NSString *haystack = respuesta;
    NSString *prefix = @"Aseg1_NombreCompleto:'";
    NSString *suffix = @"',Aseg1_RFC";
    NSRange prefixRange = [haystack rangeOfString:prefix];
    NSRange suffixRange = [[haystack substringFromIndex:prefixRange.location+prefixRange.length] rangeOfString:suffix];
    NSRange needleRange = NSMakeRange(prefixRange.location+prefix.length, suffixRange.location);
    NSString *needle = [haystack substringWithRange:needleRange];
    NSLog(@"needle: %@", needle);
    
    return needle;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
  //  [[self tableView]reloadData];
}
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}




- (void)insertNewObject:(id)sender
{
    if (!__objects) {
        __objects = [[NSMutableArray alloc] init];
    }
    [__objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



@end
