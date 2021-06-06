#include <stdio.h>            /* C input/output                       */
#include <stdlib.h>           /* C standard library                   */
#include <glpk.h>             /* GNU GLPK linear/mixed integer solver */
#include <math.h>

float Matriz[32][16384*2];
double valor[16384*2*32+1];
int fila[16384*2*32+1], columna[16384*2*32+1];

int main(void)
{
    float x1,Puerta[32],z,coef;
    int i,j,k,l,m;
    FILE *fp,*fg;
    i=0;j=0;
    fp = fopen("Matriz4D_Sinfases.txt","r");

    while(fscanf(fp,"%f", &x1)!=EOF)
    {
        
        Matriz[j][i]=x1;
        if(((i+1) % (16384*2))== 0){i=0;j=j+1;}
        else{i=i+1;}
    }


    fclose(fp);
    i=0;
    fg = fopen("Puerta4qubits.txt","r");  
    while(fscanf(fg,"%f\n", &x1)!=EOF)
    {
        Puerta[i]=x1;
        i=i+1;
    }  

    fclose(fg);

    glp_prob *lp; /*Declarar el problema lineal*/
    lp = glp_create_prob();
    glp_set_prob_name(lp, "sample");
    glp_set_obj_dir(lp, GLP_MIN);

    glp_add_rows(lp, 32);/*filas, elementos de la matriz a descomponer*/
    for ( i = 0; i < 32; i++)
    {
        glp_set_row_bnds(lp, (i+1), GLP_FX, Puerta[i], Puerta[i]);
    }
    
    glp_add_cols(lp, 16384*2);

    for ( i = 0; i < (16384*2); i++)
    {
        glp_set_col_bnds(lp,(i+1),GLP_LO,0.0,0.0);
        glp_set_obj_coef(lp, (i+1), 1.0);
    }

    k=1;
    l=1;
    for (j = 1; j < 33; j++)
    { 
        for ( i = 1; i < (16384*2+1); i++)
        { 
            fila[l]=j;
            columna[l]=i;
            valor[l]=Matriz[j-1][i-1];
      
      l=l+1;

        }
    }
   

    

    glp_load_matrix(lp, 1048576, fila, columna, valor);
    glp_simplex(lp, NULL);
    z = glp_get_obj_val(lp);

 int L;
 L=0;
 for ( i = 0; i < 16384*2; i++)
    {
        coef=(glp_get_col_prim(lp,(i+1)));
        if ((coef > 0.000001) && (coef> -0.000001))
        {   
            L=L+1;
            /*fprintf(fv,"Valor del coeficiente %f\n",coef);*/
            printf("%d\t%f\n",(i+1),coef);
            for ( j = 0; j < 32; j++)
            {
                printf("%f\n",Matriz[j][i]);

            }
        }

    }

    printf("Número de elementos descomposición: %i \n",L);
    printf("z = %f\n", z);
    glp_delete_prob(lp);/*Borrar el programa*/
    glp_free_env();/*Free enviroment, básicamente*/
    
    return 0;
}