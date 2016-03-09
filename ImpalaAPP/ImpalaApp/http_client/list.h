#define MAX_LISTS 1

#include <stdlib.h>
#include <stdio.h>

/*
 * Define las cabeceras de los archivos utilizados para implementar la
 * estructura de datos listas de ligadura doble.
 * Creado por: Manuel Ignacio Castillo López,
 * manuel_castillo_cc@ciencias.unam.mx
 * Versión 1, agosto 2013.
 */

// define el elemento portado por cada nodo de la lista
typedef struct holds
{
	char document_id[15];
	char document_name[100];
	char expire_date[30];
	unsigned short int type;
	void *beneficiaries;
} holds;

/*
 * Define un nodo en una lista ligada doble. Éste contiene un apuntador al
 * siguiente nodo en la lista; o a NULL si se trata del último elemento; y de
 * la misma manera para el anterior.
 */
typedef struct node
{
    holds element;
    struct node *next;
    struct node *previous;
} node;

//cabezas de las listas
node *head[MAX_LISTS];
//colas de las listas
node *tail[MAX_LISTS];
//tamaños de las listas
unsigned long long int size[MAX_LISTS];

/* prototipos de funciones
 * Pretenden modelar un tipo de datos abstracto "Lista"
 */
void create(holds, unsigned short int);
void insert(int, holds, unsigned short int);
void insertf(int, holds, node*, unsigned short int, unsigned short int);
void errase_all(unsigned short int);
void errase(int, unsigned short int);
void errasef(int, node*, unsigned short int, unsigned short int);
holds get(int, unsigned short int);
holds getf(int, node*, unsigned short int);
short unsigned int is_empty(unsigned short int);
unsigned long long int get_size(unsigned short int);
node* get_head(unsigned short int);
void swap(node*, node*, unsigned short int);
node* get_node(int, unsigned short int);
node* get_nodef(int, node*, unsigned short int);
node* get_tail(unsigned short int);

