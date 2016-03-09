//
//  cliente_http.h
//  ImpalaApp
//
//  Created by Guillermo Vera on 4/20/14.
//  Copyright (c) 2014 Guillemo Vera. All rights reserved.
//

#ifndef ImpalaApp_cliente_http_h
#define ImpalaApp_cliente_http_h
int init();
//Dice si existe el usuario o no
int existeOno(char* numPoliza,char*inicioVigencia,char*nacimientoCliente,char*rfc);
char* autenificaWeb( char* email, char* password);
char* readInfoData();

#endif
