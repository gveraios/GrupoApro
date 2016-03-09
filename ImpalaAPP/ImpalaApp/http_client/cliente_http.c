#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <netdb.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include "list.h"
#include "cliente_http.h"
#define USERAGENT "NACHINTOCH-SOAPCLIENT 1.0"
#define MESSAGELENGTH 5000

/*
 * Cliente de SOAP v1
 *
 * Autor: Manuel Ignacio Castillo López "Nachintoch The White"
 * teshanatsch@gmail.com
 * Autor: SoftLotto "Más que un software, una solución"
 * Version 0.0.0,  abril, 2014
 */

//prototipos de funciones
void create_socket();
void get_ip();
char *build_query(unsigned short int, char *, char*[]);
void die();
void build_message(unsigned short int, char *, char *, char*[]);
void receive_message(char *);
unsigned short int user_exists(char *);
void send_message(char *);
int receive_policy_data(char *);

// variables globales

//apuntador al socket de la aplicación
int sock;
//dirección IP y cadena con el mensaje de consulta a SICAS Web Service Online
char *ip;
//estructura del socket
struct sockaddr_in *remote;
//dirección de Internet de SICAS Web Servce
char *host = "www.sicasonline.com";
//página donde el servidor responde a mensajes SOAP
char *page = "/SICASOnline/WS_SICASOnline.asmx";
//entero multipropósito para recibir datos por red
int n;
//estructura que define el máximo tiempo de espera de cada mensaje
struct timeval tv;
//contiene el identificador del usuario WEB dentro de SICAS Web Service
char client_id[15];
//indica si la recepcion de datos no ha terminado
unsigned short int unfinished = 0;
//Dice si existe el usuario o no
int existeOno(char* numPoliza,char*inicioVigencia,char*nacimientoCliente,char*rfc);
char* autenificaWeb( char* email, char* password);
char* readInfoData();


/*
 * Controla un cliente de HTTP/SOAP haciendo un POST a la página de SICAS Web
 * Service Online y mostrando los resultados al terminar.
 */

int existeOno(char* numPoliza,char*inicioVigencia,char*nacimientoCliente,char*rfc){
    char *params[5];
	for(n = 0; n < 5; n++)
	{
		params[n] = malloc(512);
	}//inicializa el arreglo de parámetros
	get_ip();
	// <VerifyExistClient>
    //22893
    /** Datos prueba
     strcpy(params[0], "PRUEBAVARIOSANIOS");//número de póliza
     strcpy(params[1], "2013-10-24T00:00:00");//fecha de inicio de vigencia
     strcpy(params[2], "1974-05-23T00:00:00");//fecha de nacimiento del cliente
     strcpy(params[3], "BORV-740523-MV5");//RFC del cliente
     */
	strcpy(params[0], numPoliza);//número de póliza
	strcpy(params[1], inicioVigencia);//fecha de inicio de vigencia
	strcpy(params[2], nacimientoCliente);//fecha de nacimiento del cliente
	strcpy(params[3], rfc);//RFC del cliente
	send_message(build_query(0, "http://tempuri.org/VerifyExistClient", params));
	char *content = malloc(4000);
	receive_message(content);
    printf("RESP ES %s",content);
	if(!user_exists(content))
	{
		printf("No hay un usuario para las credenciales dadas\n");
		return 0;
	}//verifica que el usuario exista
	// </VerifyExistClient>*/
    return 1;
}

char* autenificaWeb( char* email, char* password){
    char *params[5];
    char *content = malloc(4000);
	for(n = 0; n < 5; n++)
	{
		params[n] = malloc(512);
	}//inicializa el arreglo de parámetros
	get_ip();
    // <AutentificarWEB>
    /** Datos Prueba
     * vmanuelb@tsmexico.com.mx
     * 123456
     */
	strcpy(params[0], email);//usuario web
	strcpy(params[1], password);//password
	send_message(build_query(1, "http://tempuri.org/AutenticarWEB", params));
	//content = malloc(4000);
	receive_message(content);
	//content = strstr(content, "&lt;DATAREL&gt;");
  
    return content;
   
}

char* readInfoData(){
    char *params[5];
    char *content = malloc(4000);
	for(n = 0; n < 5; n++)
	{
		params[n] = malloc(512);
	}//inicializa el arreglo de parámetros
	get_ip();
   
	strcpy(params[0], "22893");//id
	send_message(build_query(2, "http://tempuri.org/ReadInfoData", params));
	receive_message(content);
	//content = strstr(content, "&lt;DATAREL&gt;");
    
  //  free(content);
    return content;

}

int init()
{
	char *params[5];
	for(n = 0; n < 5; n++)
	{
		params[n] = malloc(512);
	}//inicializa el arreglo de parámetros
	get_ip();
	// <VerifyExistClient>
	strcpy(params[0], "PRUEBAVARIOSANIOS");//número de póliza
	strcpy(params[1], "2013-10-24T00:00:00");//fecha de inicio de vigencia
	strcpy(params[2], "1974-05-23T00:00:00");//fecha de nacimiento del cliente
	strcpy(params[3], "BORV-740523-MV5");//RFC del cliente
	send_message(build_query(0, "http://tempuri.org/VerifyExistClient", params));
	char *content = malloc(4000);
	receive_message(content);
	if(!user_exists(content))
	{
		printf("No hay un usuario para las credenciales dadas\n");
		die();
	}//verifica que el usuario exista
	// </VerifyExistClient>*/
	// <AutentificarWEB>
	strcpy(params[0], "vmanuelb@tsmexico.com.mx");//usuario web
	strcpy(params[1], "123456");//password
	send_message(build_query(1, "http://tempuri.org/AutenticarWEB", params));
	content = malloc(4000);
	receive_message(content);
	content = strstr(content, "&lt;DATAREL&gt;");
	content += 15;
	unsigned int i;
	for(i = 0; (content[i] != '&' || content[i +1] != 'l' ||
		content[i +2] != 't' || content[i +3] != ';' || content[i +4] != '/' ||
		content[i +5] != 'D' || content[i +6] != 'A' || content[i +7] != 'T' ||
		content[i +8] != 'A' || content[i +9] != 'R' ||
		content[i +10] != 'E' || content[i +11] != 'L' ||
		content[i +12] != '&' || content[i +13] != 'g' ||
		content[i +14] != 't' || content[i +15] != ';') && i < 15; i++)
	{
		client_id[i] = content[i];
	}//copia el id del usuario WEB
    printf("nnnn  nknkk");

	client_id[i] = 0;
	// </AutentificarWEB>
	// <ReadInfoData>
    strcpy(params[0], "22893");
	send_message(build_query(2, "http://tempuri.org/ReadInfoData", params));
	/* vamos a usar state para indicar si se comienza a construir una póliza
	 * nueva o continuamos con las construcción de una anterior. Para ello,
	 * nos indicará los siguientes pasos:
	 * 0 - coloca el identificador de documento (crea una póliza nueva)
	 * 1 - Coloca el número de póliza
	 * 2 - Coloca la fecha de caducidad
	 * 3 - Agrega el ramo de la póliza
	 */
	unsigned short int state = 0;
	unsigned short int cont = 1;
	unsigned short int lastcount = 0;
	char *aux = malloc(15);
	holds* to_hold;
	memset(content, 0, 4000);
	while(receive_policy_data(content) > 0)
	{
		while(cont) {
			switch(state) {
			case 0 :
				for(i = 0; (lastcount == 0) && (content[i] != '\0') &&
					(content[i] != '&' || content[i +1] != 'l' ||
					content[i +2] != 't' || content[i +3] != ';' ||
					content[i +4] != 'I' || content[i +5] != 'D' ||
					content[i +6] != 'D' || content[i +7] != 'o' ||
					content[i +8] != 'c' || content[i +9] != 't' ||
					content[i +10] != 'o' || content[i +11] != '&' ||
					content[i +12] != 'g' || content[i +13] != 't' ||
					content[i +14] != ';'); i++);
				if((content == NULL) || (strlen(content) == 0))
				{
					cont = 0;
					break;
				}//si hay más que ver
				if(lastcount == 0)
				{
					content += i +15;
					to_hold = malloc(sizeof(holds));
					insert(0, *to_hold, 0);
				}//si no se quedó un mensaje a medias
				for(i = lastcount; content[i] != '\0' && (content[i] != '&' ||
					content[i +1] != 'l' || content[i +2] != 't' ||
					content[i +3] != ';' || content[i +4] != '/' ||
					content[i +5] != 'I' || content[i +6] != 'D' ||
					content[i +7] != 'D' || content[i +8] != 'o' ||
					content[i +9] != 'c' || content[i +10] != 't' ||
					content[i +11] != 'o' || content[i +12] != '&' ||
					content[i +13] != 'g' || content[i +14] != 't' ||
					content[i +15] != ';') && i < 15;
					i++)
				{
					to_hold -> document_id[i] = content[i];
				}//copia el id del documento
				if((content == NULL) || (strlen(content) == 0) ||
					(content[i] == 0))
				{
					lastcount = i;
					cont = 0;
					break;
				}//si hay más que ver
				lastcount = 0;
				to_hold -> document_id[i] = 0;
				content += i +15;
				break;
			case 1 :
				for(i = 0; (lastcount == 0) && (content[i] != '\0') && (content[i] != '&' ||
					content[i +1] != 'l' || content[i +2] != 't' ||
					content[i +3] != ';' || content[i +4] != 'D' ||
					content[i +5] != 'o' || content[i +6] != 'c' ||
					content[i +7] != 'u' || content[i +8] != 'm' ||
					content[i +9] != 'e' || content[i +10] != 'n' ||
					content[i +11] != 't' || content[i +12] != 'o' ||
					content[i +13] != '&' || content[i +14] != 'g' ||
					content[i +15] != 't' || content[i +16] != ';'); i++);
				if((content == NULL) || (strlen(content) == 0))
				{
					cont = 0;
					break;
				}//si hay más que ver
				if(lastcount == 0)
				{
					content += i +16;
				}//si no es un mensaje que se quedó a medias
				for(i = lastcount; content[i] != '\0' && (content[i] != '&' ||
					content[i +1] != 'l' || content[i +2] != 't' ||
					content[i +3] != ';' || content[i +4] != '/' ||
					content[i +5] != 'D' || content[i +6] != 'o' ||
					content[i +7] != 'c' || content[i +8] != 'u' ||
					content[i +9] != 'm' || content[i +10] != 'e' ||
					content[i +11] != 'n' || content[i +12] != 't' ||
					content[i +13] != 'o' || content[i +14] != '&' ||
					content[i +15] != 'g' || content[i +16] != 't' ||
					content[i +17] != ';') && i < 100;
					i++)
				{
					to_hold -> document_name[i] = content[i];
				}//copia el número de póliza
				if((content == NULL) || (strlen(content) == 0) ||
					(content[i] == 0))
				{
					lastcount = i;
					cont = 0;
					break;
				}//si hay más que ver
				lastcount = 0;
				to_hold -> document_name[i] = 0;
				content += i +17;
				break;
			case 2 :
				for(i = 0; (lastcount == 0) && (content[i] != '\0') &&
					(content[i] != '&' || content[i +1] != 'l' ||
					content[i +2] != 't' || content[i +3] != ';' ||
					content[i +4] != 'F' || content[i +5] != 'H' ||
					content[i +6] != 'a' || content[i +7] != 's' ||
					content[i +8] != 't' || content[i +9] != 'a' ||
					content[i +10] != '&' || content[i +11] != 'g' ||
					content[i +12] != 't' || content[i +13] != ';'); i++);
				if((content == NULL) || (strlen(content) == 0))
				{
					cont = 0;
					break;
				}//si hay más que ver
				if(lastcount == 0)
				{
					content += i +13;
				}//si no es un mensaje mocho
				for(i = lastcount; content[i] != '\0' && (content[i] != '&' ||
					content[i +1] != 'l' || content[i +2] != 't' ||
					content[i +3] != ';' || content[i +4] != '/' ||
					content[i +5] != 'F' || content[i +6] != 'H' ||
					content[i +7] != 'a' || content[i +8] != 's' ||
					content[i +9] != 't' || content[i +10] != 'a' ||
					content[i +11] != '&' || content[i +12] != 'g' ||
					content[i +13] != 't' || content[i +14] != ';') && i < 30;
					i++)
				{
					to_hold -> document_name[i] = content[i];
				}//copia la fecha de caducidad de la póliza
				if((content == NULL) || (strlen(content) == 0) ||
					(content[i] == 0))
				{
					lastcount = i;
					cont = 0;
					break;
				}//si hay más que ver
				to_hold -> document_name[i] = 0;
				content += i +13;
				lastcount = 0;
				break;
			case 3 :
				for(i = 0; (lastcount == 0) && (content[i] != '\0') &&
					(content[i] != '&' || content[i +1] != 'l' ||
					content[i +2] != 't' || content[i +3] != ';' ||
					content[i +4] != 'R' || content[i +5] != 'a' ||
					content[i +6] != 'm' || content[i +7] != 'o' ||
					content[i +8] != 's' || content[i +9] != 'A' ||
					content[i +10] != 'b' || content[i +11] != 'r' ||
					content[i +12] != 'e' || content[i +13] != 'v' ||
					content[i +14] != 'i' || content[i +15] != 'a' ||
					content[i +16] != 'c' || content[i +17] != 'i' ||
					content[i +18] != 'o' || content[i +19] != 'n' ||
					content[i +20] != '&' || content[i +21] != 'g' ||
					content[i +22] != 't' || content[i +23] != ';'); i++);
				if((content == NULL) || (strlen(content) == 0))
				{
					cont = 0;
					break;
				}//si hay más que ver
				if(lastcount == 0)
				{
					content += i +23;
				}//si no es un mensaje mocho
				for(i = lastcount; content[i] != '\0' && (content[i] != '&' ||
					content[i +1] != 'l' || content[i +2] != 't' ||
					content[i +3] != ';' || content[i +4] != '/' ||
					content[i +5] != 'R' || content[i +6] != 'a' ||
					content[i +7] != 'm' || content[i +8] != 'o' ||
					content[i +9] != 's' || content[i +10] != 'A' ||
					content[i +11] != 'b' || content[i +12] != 'r' ||
					content[i +13] != 'e' || content[i +14] != 'v' ||
					content[i +15] != 'i' || content[i +16] != 'a' ||
					content[i +17] != 'c' || content[i +18] != 'i' ||
					content[i +19] != 'o' || content[i +20] != 'n' ||
					content[i +21] != '&' || content[i +22] != 'g' ||
					content[i +23] != 't' || content[i +24] != ';') && i < 15;
					i++)
				{
					aux[i] = content[i];
				}//copia el id del usuario WEB
				if((aux == NULL) || (strlen(aux) == 0) || (aux[i] == 0))
				{
					lastcount = i;
					cont = 0;
					break;
				}//si hay más que ver
				aux[i] = 0;
				lastcount = i;
				if(strcmp(aux, "VIDA") == 0)
				{
					to_hold -> type = 0;
				}
				else if(strcmp(aux, "GM") == 0)
				{
					to_hold -> type = 2;
				}
				else if(strcmp(aux, "VEHIC") == 0)
				{
					to_hold -> type = 1;
				}
				else
				{
					to_hold -> type = 3;
				}//asigna el código de tipo de póliza
				content += i +17;
			}//constuye la póliza de acuerdo a la fase en la que se encuentre
			state = (state +1) %4;
		}//podría haber infromación de muchas pólizas en la misma lectura
		memset(content, 0, 4000);
	}//recupera poco a poco los mensajes de detalle de póliza
	holds tohold;
	for(i = 0; i < get_size(0); i++)
	{
		tohold = get(i, 0);
		printf("ID = %s\n", tohold.document_id);
		printf("Poliza = %s\n", tohold.document_name);
		printf("Caducidad = %s\n", tohold.expire_date);
		printf("Tipo de documento = %i\n\n", tohold.type);
	}
	close(sock);
	// </ReadInfoData>*/
	printf("Se recivió: %s\n\n", content);//TODO sobra
	//free(content);
	return 0;
}//main

// obtiene una IP de la dirección de Internet del SICAS Web Service
void get_ip()
{
	struct hostent *hent;
	int iplen = 15;
	ip = (char *) malloc(iplen +1);
	memset(ip, 0, iplen +1);
	if((hent = gethostbyname(host)) == NULL)
	{
		herror("No es posible obtener la IP");
		exit(EXIT_FAILURE);
	}//si ocurre un error al tratar de obtener la IP
	if(inet_ntop(AF_INET, (void *) hent -> h_addr_list[0], ip, iplen) == NULL)
	{
		perror("No es posible resolver el nombre de servicio dado");
		exit(EXIT_FAILURE);
	}//obitne la IP del servicio
}//get_ip

//construye una consulta al server
char *build_query(unsigned short int service, char *action, char *params[])
{
	char *query;
	//char *getpage = page;
	char *tpl = "POST /SICASOnline/WS_SICASOnline.asmx HTTP/1.1\r\nAccept: text/xml\r\nSOAPAction: %s\r\nContent-Type: text/xml; charset=utf-8\r\nHost: www.sicasonline.com\r\nConnection: keep-alive\r\nUser-Agent: NACHINTOCH-SOAPCLIENT 1.0\r\nContent-Length: %s\r\n\r\n%s\r\n\r\n";
	char *soap_action = malloc(256);
	char *message = malloc(MESSAGELENGTH);
	build_message(service, message, soap_action, params);
	query = malloc(252 +strlen(soap_action) +strlen(message));
	char len[15];
	sprintf(len, "%d", strlen(message));
	sprintf(query, tpl, soap_action, len, message);
	return query;
}//build_query

//construye un mensaje SOAP para el SICAS Web Service
void build_message(unsigned short int which, char *message, char *action,
	char *params[])
{
	switch(which) {
	case 0 :
		//verifyExistClient
		memset(message, 0, MESSAGELENGTH);
		strcat(message, "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Body><VerifyExistClient xmlns=\"http://tempuri.org/\"><oConfigData><PropertyData_Documento>");
		strcat(message, params[0]);
		strcat(message, "</PropertyData_Documento><PropertyData_InicioVig>");
		strcat(message, params[1]);
		strcat(message, "</PropertyData_InicioVig><PropertyData_FechaNac>");
		strcat(message, params[2]);
		strcat(message, "</PropertyData_FechaNac><PropertyData_RFC>");
		strcat(message, params[3]);
		strcat(message, "</PropertyData_RFC><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>TSMexico</UserName><Password>TSM2012#ws02</Password></oConfigAuth></VerifyExistClient></SOAP-ENV:Body></SOAP-ENV:Envelope>");
		strcat(action, "http://tempuri.org/VerifyExistClient");
		return;
	case 1 :
		//autentificarWEB
		memset(message, 0, MESSAGELENGTH);
		strcat(message, "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><AutenticarWEB xmlns=\"http://tempuri.org/\"><oConfigData><Data_LoginUWEB>");
		strcat(message, params[0]);
		strcat(message, "</Data_LoginUWEB><Data_PasswUWEB>");
		strcat(message, params[1]);
		strcat(message, "</Data_PasswUWEB></oConfigData><oConfigAuth><UserName>TSMexico</UserName><Password>TSM2012#ws02</Password></oConfigAuth></AutenticarWEB></SOAP-ENV:Body></SOAP-ENV:Envelope>");
		strcat(action, "http://tempuri.org/AutenticarWEB");
		return;
	case 2 :
		//readInfoData
		memset(message, 0, MESSAGELENGTH);
		strcat(message, "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"><SOAP-ENV:Header/><SOAP-ENV:Body><ReadInfoData xmlns=\"http://tempuri.org/\"><oConfigData><PropertyIDData>");
		strcat(message, params[0]);
		strcat(message, "</PropertyIDData><PropertyTypeReadData>eDocumentos_Cliente</PropertyTypeReadData><PropertyData_TypeDataReturn>Data_XML</PropertyData_TypeDataReturn></oConfigData><oConfigAuth><UserName>TSMexico</UserName><Password>TSM2012#ws02</Password></oConfigAuth></ReadInfoData></SOAP-ENV:Body></SOAP-ENV:Envelope>");
		strcat(action, "http://tempuri.org/ReadInfoData");
		return;
	default :
		printf("El se reconoce el servicio remoto %i", which);
		die();
	}//crea un mensaje dependiendo el caso
}//build_message

//termina el programa en stado abnormal
void die()
{
	free(remote);
	free(ip);
	close(sock);
	exit(EXIT_FAILURE);
}//die

// crea un socket de TCP
void create_socket()
{
	if((sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
	{
		perror("Error al crear el socket");
		exit(EXIT_FAILURE);
	}//comprueba que se haya creado el socket
}//create_socket

//recibe un mensaje de respuesta de SICAS Web Service Online
void receive_message(char *body)
{
	unsigned short int i;
	unsigned int headlen = 0;
	unsigned int data = 0;
	char *prehead;
	char *content = malloc(BUFSIZ);
	char *buffer = malloc(BUFSIZ);
	while((n = recv(sock, buffer, BUFSIZ, 0)) > 0)
	{
		strcpy(content, buffer);
		if(!data)
		{
			headlen = strlen(buffer);
			prehead = malloc(headlen);
			for(i = 0; (i < headlen) && (buffer[i] != '\r' ||
				buffer[i +1] != '\n' || buffer[i +2] != '\r' ||
				buffer[i +3] != '\n'); i++)
			{
				prehead[i] = buffer[i];
			}//copia el encabezado del flujo
			strcpy(content, buffer);
			content += i;
			if(content)
			{
				content += 4;
			}//si se encontró la subcadena
			strcat(body, content);
			data = 1;
		}//si no se ha recuperado el encabezado
		strcat(body, content);
		memset(buffer, 0, n);
	}//recupera los datos recibidos por el server
	strcpy(content, buffer);
	close(sock);
}//receive_message

/*
 * comprueba que el mensaje recibido por SICAS indique que el usuario dado
 * existe.
 */
unsigned short int user_exists(char *response)
{
	char *aux;
	if((aux = strstr(response, "VerifyExistClientResult")))
	{
		return (strstr(response, "SUCESS") != NULL);
	}//si obtiene un resutado
	return 0;
}//user_exist

// envía un mensaje SOAP al servidor de SICAS Web Service
void send_message(char *message)
{
    printf("%s",message);
	create_socket();
	remote = (struct sockaddr *) malloc(sizeof(struct sockaddr_in));
	remote -> sin_family = AF_INET;
	n = inet_pton(AF_INET, ip, (void *) (&(remote -> sin_addr.s_addr)));
	if(n < 0)
	{
		printf("Ocurri\u00F3 un problema al obtener el servicio remoto\n");
		exit(EXIT_FAILURE);
	}
	else if(n == 0)
	{
		printf("La IP obtenida no es v\u00E1lida\n");
		exit(EXIT_FAILURE);
	}//resuelve la conexión
	remote -> sin_port = htons(80);
	if(connect(sock, (struct sockaddr *) remote, sizeof(struct sockaddr)) < 0)
	{
		perror("Error al conectar");
		exit(EXIT_FAILURE);
	}//conecta
	tv.tv_sec = 2;//2 segundos de timeout
	tv.tv_usec = 0;
	setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char *) &tv,
		sizeof(struct timeval));
	int sent = 0;
	int length = strlen(message);
	while(sent < length)
	{
		n = send(sock, message +sent, length -sent, 0);
		if(n == -1)
		{
			perror("No es posible enviar una petici\u00F3n al server");
			exit(EXIT_FAILURE);
		}//si ocurre un error de salida
		sent += n;
	}//envía la petición al server
}//send_message

/*
 * recibe un mensaje de respuesta de SICAS Web Service Online con datos de
 * pólizas del usuario web que se haya solicitado
 */
int receive_policy_data(char *policy)
{
	char *buffer = malloc(BUFSIZ);
	if((n = recv(sock, buffer, BUFSIZ, 0)) > 0)
	{
		strcat(policy, buffer);
	}//recupera los datos recibidos por el server
    free(buffer);
	return n;
}//receive_message

