/*
 * Define las funcoones para trabajar con la estructura de datos listas de
 * ligadura doble.
 * Creado por: Manuel Ignacio Castillo López,
 * manuel_castillo_cc@ciencias.unam.mx
 * Versión 1, agosto 2013.
 */
#include "list.h"

/*
 * crea una lista con el contenido dado
 */
void create(holds toHold, unsigned short int id)
{
    errase_all(id);
    head[id] = (node*) malloc(sizeof(node));
    head[id] -> element = toHold;
    head[id] -> next = NULL;
    head[id] -> previous = NULL;
    tail[id] = head[id];
    size[id] = 1;
}//create

/*
 * inserta el elemento dado en la posición i-ésima de la lista a partir del
 * nodo indicado; asignano una dirección de movimiento
 */
void insert(int i, holds newElement, unsigned short int id)
{
    if((size[id] /2.0) > i)
    {
        insertf(i, newElement, head[id], 1, id);
    }
    else
    {
        insertf(size[id] -i +1, newElement, tail[id], 0, id);
    }
}//inserts

/*
 * inserta el elemento dado en la posición i-ésima de la lista a partir del
 * nodo indicado moviendose en la direccion indicada
 */
void insertf(int i, holds newElement, node *from, unsigned short int dir, unsigned short int id)
{
    if(i < 0)
    {
        printf("Invalid index. Must be greater or equal to 0\n");
        return;
    }
    else if((from == NULL) && (i != 0) && (!is_empty(id)))
    {
        printf("Invalid index. Out of bounds\n");
        return;
    }//controla que los datos de entrada sean válidos
    if(i == 0)
    {
        if(size[id] == 0)
        {
            create(newElement, id);
        }
        else
        {
            node *aux = (node*) malloc(sizeof(node));
            aux -> element = newElement;
            aux -> previous = NULL;
            aux -> next = head[id];
            head[id] -> previous = aux;
            head[id] = aux;
            size[id]++;
        }//la lista era vacía y la crea
        return;
    }
    else if(i == 1)
    {
        if(is_empty(id))
        {
        	create(newElement, id);
        	return;
        }
        else if(from == tail[id])
        {
            node *aux = (node*) malloc(sizeof(node));
            aux -> element = newElement;
            tail[id] -> next = aux;
            aux -> previous = tail[id];
            aux -> next = NULL;
            tail[id] = aux;
            size[id]++;
            return;
        }//inserta en los extremos
        node *aux = from -> next;
        if(aux != NULL)
        {
            node *temp = (node*) malloc(sizeof(node));
            temp -> element = newElement;
            temp -> previous = from;
            temp -> next = aux;
            from -> next = temp;
            aux -> previous = temp;
        }
        else
        {
            aux = (node*) malloc(sizeof(node));
            aux -> element = newElement;
            aux -> next = tail[id];
            aux -> previous = from;
            from -> next = aux;
            tail[id] -> previous = aux;
        }//inserta dependiendo si from es nulo o no
        size[id]++;
    }
    else
    {
        if(dir)
        {
            insertf(i -1, newElement, from -> next, dir, id);
        }
        else
        {
            insertf(i -1, newElement, from -> previous, dir, id);
        }
    }//inserta si alcanzó su destino o recorre de lo contrario
}//insert

/*
 * Quita todos los elementos de la lista
 */
void errase_all(unsigned short int id)
{
    while(head[id] != NULL)
    {
        errasef(0, head[id], 1, id);
    }//quita todos los elementos
}//errase_all

/*
 * Establece la dirección de movimiento para el borrado de un elemento
 */
void errase(int i, unsigned short int id)
{
    if((size[id] /2.0) > i)
    {
        errasef(i, head[id], 1, id);
    }
    else
    {
        errasef(size[id] -i +1, tail[id], 0, id);
    }
}//errase

/*
 * Quita un elemento específico de la lista; búscandolo en la diección dada
 */
void errasef(int i, node *from, unsigned short int dir, unsigned short int id)
{
    if(i == -1)
    {
        free(head[id]);
        head[id] = NULL;
        free(tail[id]);
        tail[id] = NULL;
        size[id] = 0;
        return;
    }//comprueba si se inicializa por primera vez
    if(i < 0)
    {
        printf("Invalid index. Must be greater or equal to 0\n");
        return;
    }
    else if((from == NULL) && (i >= 0))
    {
        printf("This is the end of the list. I mean; you already past it.\n");
        printf("Nothing was done,");
        printf(" since after the tail there is nothing to delete\n");
        return;
    }//controla que los datos de entrada sean válidos
    if(i == 0) {
        if((head[id] -> next) == NULL)
        {
            free(head[id]);
            head[id] = NULL;
            size[id] = 0;
        }
        else
        {
            node *temp = head[id] -> next;
            head[id] -> next = NULL;
            temp -> previous = NULL;
            head[id] = temp;
            size[id]--;
        }//borra la cabeza
    }
    else if(i == 1)
    {
        if(from == tail[id])
        {
            printf("This is the end of the list.");
            printf(" I mean; you already past it.\n");
            printf("Nothing was done,");
            printf(" since after the tail there is nothing to delete\n");
            return;
        }
        else if(from -> next == tail[id])
        {
            from -> next = NULL;
            tail[id] -> previous = NULL;
            tail[id] = from;
            size[id]--;
        }
        else
        {
            node *temp = from -> next;
            from -> next = temp -> next;
            (temp -> next) -> previous = from;
            temp -> next = NULL;
            temp -> previous = NULL;
            free(temp);
            temp = NULL;
            size[id]--;
        }//elimina un elemento dado
    }
    else
    {
        if(dir)
        {
            errasef(i -1, from -> next, dir, id);
        }
        else
        {
            errasef(i -1, from -> previous, dir, id);
        }
    }//inserta si alcanzó su destino o recorre de lo contrario
}//errase

/*
 * Indica la dirección en la que se debe mover la función que busca el i-ésimo
 * elemento en la lista
 */
holds get(int i, unsigned short int id)
{
    if((size[id] /2.0) > i)
    {
    	return getf(i, head[id], 1);
    }
    else
    {
    	return getf(size[id] -i +1, tail[id], 0);
    }
}//get

/*
 * Obtiene el elemento del nodo en el índice dado
 */
holds getf(int i, node *from, unsigned short int dir)
{
    if(i < 0)
    {
        printf("Invalid index. Must be greater or equal to 0\n");
        holds nothing;
        return nothing;
    }
    else if((from == NULL) && (i != 0))
    {
        printf("Invalid index. Out of bounds\n");
        holds nothing;
        return nothing;
    }//controla que los datos de entrada sean válidos
    if(i == 0)
    {
        return from -> element;
    }
    else
    {
        if(dir)
        {
        	return getf(i -1, from -> next, dir);
        }
        else
        {
        	return getf(i -1, from -> previous, dir);
        }
    }//devuelve el elemento buscado o sigue buscando
}//get

/*
 * Indica si la lista es vacía o no
 */
short unsigned int is_empty(unsigned short int id)
{
    if((head[id] == NULL) || (size[id] == 0))
        return 1;
    else
        return 0;
}//is_empty

/*
 * Indica el tamaño de la lista
 */
unsigned long long int get_size(unsigned short int id)
{
    return size[id];
}//get_size

/*
 * devuelve la cabeza de la lista
 */
node* get_head(unsigned short int id)
{
    return head[id];
}//get_head

/*
 * intercambia los nodos dados.
 */
void swap(node* i, node* j, unsigned short int id)
{
    if((i == NULL) || (j == NULL))
    {
    	printf("Ninguno de los nodos a intercambiar pueden ser nulos\n");
    	return;
    } if(i == j)
    {
    	return;
    }//comprueba los casos tribiales
    if(((i == head[id]) && (j == tail[id])) || ((i == tail[id]) && (j == head[id])))
    {
    	node *aux_h = head[id] -> next;
    	node *aux_t = tail[id] -> previous;
    	head[id] -> next = NULL;
    	head[id] -> previous = aux_t;
    	tail[id] -> next = aux_h;
    	tail[id] -> previous = NULL;
    	aux_t -> next = head[id];
    	aux_h -> previous = tail[id];
    	aux_h = head[id];
    	head[id] = tail[id];
    	tail[id] = aux_h;
    }
    else if((i == head[id]) || (j == head[id]))
    {
    	if(j == head[id])
    	{
    		j = i;
    	}//el swap es conmutativo
    	if((j -> previous) == head[id])
    	{
    		node *aux_jn = j -> next;
    		head[id] -> next = aux_jn;
    		head[id] -> previous = j;
    		aux_jn -> previous = head[id];
    		j -> next = head[id];
    		j -> previous = NULL;
    		head[id] = j;
    	}
    	else
    	{
    		node *aux_h = head[id] -> next;
			node *aux_jp = j -> previous;
			node *aux_jn = j -> next;
			head[id] -> next = aux_jn;
			head[id] -> previous = aux_jp;
			j -> next = aux_h;
			j -> previous = NULL;
			aux_jn -> previous = head[id];
			aux_jp -> next = head[id];
			aux_h -> previous = j;
			head[id] = j;
    	}
    }
    else if((i == tail[id]) || (j == tail[id]))
    {
    	if(j == tail[id])
    	{
    		j = i;
    	}//el swap es conmutativo
    	if((j -> next) ==  tail[id])
    	{
    		node *aux_jp = j -> previous;
    		aux_jp -> next = tail[id];
    		tail[id] -> previous = aux_jp;
    		j -> next = NULL;
    		j -> previous = tail[id];
    		tail[id] -> next = j;
    		tail[id] = j;
    	}
    	else
    	{
    		node *aux_t = tail[id] -> previous;
			node *aux_jp = j -> previous;
			node *aux_jn = j -> next;
			tail[id] -> next = aux_jn;
			tail[id] -> previous = aux_jp;
			j -> next = NULL;
			j -> previous = aux_t;
			aux_jn -> previous = tail[id];
			aux_jp -> next = tail[id];
			aux_t -> next = j;
			tail[id] = j;
    	}
    }
    else if(((j -> next) == i) || ((j -> previous) == i)){
    	if((j -> next) == i)
    	{
    		node *auxt = i;
    		i = j;
    		j = auxt;
    	}//el swap en conmutativo
    	node* aux_jn = j -> next;
		node* aux_ip = i -> previous;
		i -> next = aux_jn;
		j -> previous = aux_ip;
		j -> next = i;
		i -> previous = j;
		aux_ip -> next = j;
		aux_jn -> previous = i;
    }
    else
    {
    	node *aux_jp = j -> previous;
    	node *aux_jn = j -> next;
    	node *aux_ip = i -> previous;
    	node *aux_in = i -> next;
    	i -> next = aux_jn;
    	i -> previous = aux_jp;
    	j -> next = aux_in;
    	j -> previous = aux_ip;
    	aux_jp -> next = i;
    	aux_jn -> previous = i;
    	aux_ip -> next = j;
    	aux_in -> previous = j;
    }//reacomoda cuidando los extremos de la lista
}//swap

/*
 * Indica la dirección del movimiento para get_node
 */
node* get_node(int i, unsigned short int id)
{
	if((size[id] /2.0) > i)
	{
		return get_nodef(i, head[id], 1);
	}
	else
	{
		return get_nodef(size[id] -i +1, tail[id], 0);
	}
}//get_node

/*
 * Obtiene el nodo en el índice dado
 */
node* get_nodef(int i, node *from, unsigned short int dir)
{
    if(i < 0)
    {
        printf("Invalid index. Must be greater or equal to 0\n");
        node* nothing = NULL;
        return nothing;
    }
    else if((from == NULL) && (i <= 0))
    {
        printf("Invalid index. Out of bounds\n");
        node* nothing = NULL;
        return nothing;
    }//controla que los datos de entrada sean válidos
    if(i == 0)
    {
        return from;
    }
    else
    {
        if(dir)
        {
        	return get_nodef(i -1, from -> next, dir);
        }
        else
        {
        	return get_nodef(i -1, from -> previous, dir);
        }
    }//devuelve el elemento buscado o sigue buscando
}//get_node

/*
 * Devuelve la referencia al nodo cola.
 */
node* get_tail(unsigned short int id)
{
	return tail[id];
}//get_tail

