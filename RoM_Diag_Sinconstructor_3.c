#include <stdio.h>            /* C input/output                       */
#include <stdlib.h>           /* C standard library                   */
#include <glpk.h>             /* GNU GLPK linear/mixed integer solver */
#include <math.h>

float Matriz[16][1024];
double valor[16384+1];
int fila[16384+1], columna[16384+1];

int main(void)
{
    float x1,Puerta[16],z, coef;
    int i,j,k,l,m;
    FILE *fp,*fg,*fv;
    i=0;j=0;
    fp = fopen("Matriz3D_Sinfases.txt","r");

    while(fscanf(fp,"%f", &x1)!=EOF)
    {
        
        Matriz[j][i]=x1;
        if(((i+1) % 1024)== 0){i=0;j=j+1;}
        else{i=i+1;}
    }

    fclose(fp);
    i=0;
    fg = fopen("Puerta.txt","r");  
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

    glp_add_rows(lp, 16);/*filas, elementos de la matriz a descomponer*/
    for ( i = 0; i < 16; i++)
    {
        glp_set_row_bnds(lp, (i+1), GLP_FX, Puerta[i], Puerta[i]);
    }
    
    glp_add_cols(lp, 1024);

    for ( i = 0; i < 1024; i++)
    {
        glp_set_col_bnds(lp,(i+1),GLP_LO,0.0,0.0);
        glp_set_obj_coef(lp, (i+1), 1.0);
    }

    k=1;
    l=1;
    for (j = 1; j < 17; j++)
    { 
        for ( i = 1; i < 1025; i++)
        { 
            fila[l]=j;
            columna[l]=i;
            valor[l]=Matriz[j-1][i-1];
      
      l=l+1;

        }
    }

    glp_load_matrix(lp, 16384, fila, columna, valor);
    glp_simplex(lp, NULL);
    z = glp_get_obj_val(lp);

    fv=fopen("Resultados.txt","w");

    for ( i = 0; i < 1024; i++)
    {
        coef=(glp_get_col_prim(lp,(i+1)));
        if ((coef != 0.000000) && (coef!= -0.000000))
        {   
            fprintf(fv,"Valor del coeficiente %f\n",coef);
            printf("%d\t%f\n",(i+1),coef);
            for ( j = 0; j < 8; j++)
            {
                fprintf(fv,"%f\n",Matriz[j][i]);

            }
            
            
        
        }



    }
    
    
    
    fclose(fv);

    printf("z² = %g\n", z*z);
    glp_delete_prob(lp);/*Borrar el programa*/
    glp_free_env();/*Free enviroment, básicamente*/
    
    return 0;
}