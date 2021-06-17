/* short.c */

#include <stdio.h>            /* C input/output                       */
#include <stdlib.h>           /* C standard library                   */
#include <glpk.h>             /* GNU GLPK linear/mixed integer solver */
#include <math.h>

void Constructor1(float Clifford[768][2], float Aux[2][2][384], int n, int m);/*Aquí cortamos matriz a matriz*/
void Constructor2(float Aux[2][2][384],float Final[8][384]);/*Aquí dejamos ya la matriz en su forma final*/

int main(void)
{


  /* Declarar las variables que se van a usar. Declarar fuera del int main si hay problemas de espacio. */
  glp_prob *lp; /*Declarar el problema lineal*/

  FILE *fp,*fg; 

  float Final[8][384];
  float Aux[2][2][384];

  int n,qubits,m,dimgrupo[3];/*Vamos a calcular el número de variables que necesitamos. Serán el número de elementos del grupo de Clifford dimensión (la que sea) por dos. 
  EL por dos se debe al truco del valor absoluto.*/

  /*DImensión, le falta un factor 8. según el número de qubits. 24,11520,92897280.*/

  dimgrupo[0]=24;
  dimgrupo[1]=11520;
  dimgrupo[2]=92897280;

  qubits=1;/*Cuantos qubits? Necesitamos 2*2^(2*qubits) EL dos del principio es por la descomposición en parte real e imaginaria y lo otro
  es simplemente el número de elementos de una matriz pa los qubits que sea(producto tensorial)*/
  n=2*8*dimgrupo[0]*pow(2,qubits);
  m=pow(2,qubits);


  int i,j,k,l,contador;
  int fila[3072+1], columna[3072+1]; /*Recogen la posición en fila y columna. n es el número de elementos que hay en total*/
  double valor[3072+1], z,pi;/*El valor de la variable en la posición de la matriz dada por los anteriores vectores*/
  float Clifford[768][2],finura,paso; /*Pensar el número de la derecha que es el número de columnas de las matrices a cargar*/
  float x1,x2,x3,x4,x5,x6,x7,x8;
  float theta;
  pi=3.141592654;
  fg=fopen("P_1D.txt","w");
  /*-------------------------------------------------------------------------------------------------------------------------*/
  /*Cargar matrices de Clifford. Está hecho a parte en el escritorio*/
  i=0;j=0;
    fp = fopen("Grupo1D.txt","r");
    while(fscanf(fp ,"%f\t%f", &x1, &x2)!=EOF)/*Voy a tener que cambiarlo para cada dimension de qubits*/
      {
        Clifford[i][0]=x1;
        Clifford[i][1]=x2;
        i=i+1;
      }

    fclose(fp);
  i=0;j=0;

 /*TRADUCIMOS LAS MATRICES-----------------------------------------------------------------------------------------*/
    Constructor1(Clifford, Aux, 0,0);
    Constructor2(Aux ,Final);
  /*-------------------------------------------------------------------------------------------------------------------------*/
  finura=720.0;
  theta=0.0;
  paso=2*pi/finura;
  /* Iniciando el problema*/
  for ( contador = 0; contador < (finura+1); contador++)
  {
  
  lp = glp_create_prob();
  glp_set_prob_name(lp, "sample");
  glp_set_obj_dir(lp, GLP_MIN);/*Tipo de problema de GLP*/

  /* Rellenar el problema con todas sus variables */

  /*las filas fijan coeficientes de la matriz a descomponer!!! 
  Fijamos que la descomposición sea fijar fila y correr columnas, siguiente fila y recorrer todas las columnas y así to el rato.*/


/*-------------------------------AQUI HAY QUE DEFINIR LA MATRIZ A DESCOMPONER. APLANADA, CLARO.------------------------------------------------*/

  glp_add_rows(lp, 8);/*filas, elementos de la matriz a descomponer*/



  /*Esto tiene que ser un ciclo pa meter todos los valores de la matriz a descomponer*/

  /*PARTE REAL DE LA MATRIZ --------------------------------*/
  
  glp_set_row_bnds(lp, 1, GLP_FX, 1.0, 1.0); /* Esto es para fijar los coeficientes. GLP_FX Significa que están fijados. EStos hay que fijarlos
  a la matriz que queramos descomponer. Primera prueba con la matriz identidad I=[[1,0][0,1]]*/
  glp_set_row_bnds(lp, 2, GLP_FX, 0.0, 0.0);
  
  glp_set_row_bnds(lp, 3, GLP_FX, 0.0, 0.0);

  glp_set_row_bnds(lp, 4, GLP_FX, cos(theta), cos(theta) );

    
 /* PARTE IMAGINARIA DE LA MATRIZ ----------------------------------.*/
  glp_set_row_bnds(lp, 5, GLP_FX, 0.0, 0.0);
  
  glp_set_row_bnds(lp, 6, GLP_FX, 0.0, 0.0);

  glp_set_row_bnds(lp, 7, GLP_FX, 0.0, 0.0);

  glp_set_row_bnds(lp, 8, GLP_FX, sin(theta), sin(theta));
  
  



/*------------------------------------------------------------------------------------------------------------------------------------------------*/

/*------------------------------------------AQUÍ HAY QUE CARGAR LA BASE EN LA QUE SE VA A APROYECTAR----------------------------------------------*/

  /*Añadir columnas que son nuestras variables objetivo(las que se han de calcular). GLP_FR significa que están libres. Pero nosotros
  tenemos que hacer que sean mayores de 0 y hacer el truco del valor absoluto. OJO! Utilizamos GLP_LO*/

/*-------CREAR TODAS LAS VARIABLES NECESARIAS PARA RESOLVER EL PROBLEMA, VAN DE DOS EN DOS POR LAA DESCOMPOSICIÓN DEL VALOR ABSOLUTO------------------*/

  glp_add_cols(lp, (2*8*dimgrupo[0]));/*Número de columnas que se añaden. Vamos, variables libres que tiene el problema*/
  /*Dimension=#elementosgrupo*2(real e imaginaria)*/
  for ( i = 0; i < (2*8*dimgrupo[0]); i++)
  {
    glp_set_col_bnds(lp,(i+1),GLP_LO,0.0,0.0);
    glp_set_obj_coef(lp, (i+1), 1.0);
  }
  i=0;
  

/*---CARGAR LAS MATRICES DEL GRUPO DE CLIFFORD (EN EL PROBLEMA LP) EN LAS QUE VAMOS A PROYECTAR LA MATRIZ OBJETIVO.-------------------------------*/
  /*Aquí hay que crear la matriz de coeficientes que viene dada por las matrices del grupo de Clifford*/

  k=1;
  l=1;
  for (j = 1; j < 9; j++)/*la mitad de las columnas porque repetimos con signo mas y menos*/
  { 
    for ( i = 1; i < 385; i++)/*Lleva las filas*/
    {
    
      
      fila[l]=j;
      columna[l]=i;
      valor[l]=Final[j-1][i-1];
      
      l=l+1;
        
      
      
    }
    
  }

  i=0;j=0;k=0;l=0;

  glp_load_matrix(lp, 3072, fila, columna, valor);
  /* solve problem */
  glp_simplex(lp, NULL);/*Resolvemos el problema con el método simplex*/
  /* recover and display results */
  z = glp_get_obj_val(lp);

 /* Hay que hacer prueba con matriz que esté en el grupo de CLifford. Nos debería dar 1*/
  /*printf("z = %g\n", z);*//*RoM, el valor de la magia*/
  fprintf(fg,"%f\t%f\n",theta,z);

  /* housekeeping */

  glp_delete_prob(lp);/*Borrar el programa*/
  glp_free_env();/*Free enviroment, básicamente*/
  theta=theta+paso;
  
  }



  fclose(fg);
  return 0;
}






/*------------------------------------------------------------FUNCIONES NECESARIAS----------------------------------------------------------------------*/

void Constructor1(float Clifford[768][2], float Aux[2][2][384], int n, int m)
{
  int i,j,k,l;

  for (i = 0; i < 384; i++)
  {
    for ( j = 0; j < 2; j++)
    {
      for ( k = 0; k < 2; k++)
      {
        Aux[j][k][i]=Clifford[i*2+j][k];
        
      }
      
    }
    
    
  }
  
}

void Constructor2(float Aux[2][2][384],float Final[8][384])
{
  int i,j,k,l,count;
  count=0;
  k=0;l=0;
  for ( j = 0; j < 4; j++)/*parte real*/
  {
    if (j==1)
    {
      k=0;
      l=1;

    }
    if (j==2)
    {
      k=1;
      l=0;
    }
    if (j==3)
    {
      k=1;
      l=1;
    }

    for ( i = 0; i < 192; i++)
    {
      

      Final[j][count]=Aux[k][l][2*i];
      Final[j][1+count]=-Aux[k][l][2*i];
      count=count+2;
        
    }
   
    count=0;

    k=0;
    l=0;
  }
    for ( j = 4; j < 8; j++)/*parte real*/
  {
    if (j==5)
    {
      k=0;
      l=1;

    }
    if (j==6)
    {
      k=1;
      l=0;
    }
    if (j==7)
    {
      k=1;
      l=1;
    }

    for ( i = 0; i < 192; i++)
    {
      

      Final[j][count]=Aux[k][l][2*i+1];
      Final[j][1+count]=-Aux[k][l][2*i+1];
      count=count+2;
        
    }
    
    count=0;

  }

  
}

/*27/04/2021 19:55 Compila pero no funciona.*/

/*20:31 del 27 de abril de 2021. Funciona de locos!*/