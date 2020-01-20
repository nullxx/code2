//
//  headers.c
//  CODE-2 C
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//
#include "headers.h"
registro *memoria;


char *mainProgress(int action, int r, char setString[4]){
    registro registroOrigin = getRegistro(r);
    switch (action) {
        case 0:
                {
                    // get registro valor,
                    char result[10000];
                    sprintf(result, "{\"code\": 1,\"mode\": %d,\"alias\": \"%s\", \"valor\": \"%s\", \"address\": \"%p\"}\n", action, *registroOrigin.alias, registroOrigin.valor, &registroOrigin.valor);
                    return result;
                    break;
                }
        case 1:
                {
                    // set registro valor
                    if (isCharLengthValid(setString) == 1 && isEntryValid(r, action)){
                        registro registroResult = setRegistroValue(r, setString);
                        char result[10000];
                        sprintf(result, "{\"code\": 1,\"mode\": %d,\"alias\": \"%s\", \"valor\": \"%s\", \"address\": \"%p\"}\n", action, *registroResult.alias, registroResult.valor, &registroResult.valor);
                        return result;
                    }else{
                        char result[10000];
                        sprintf(result, "{\"code\": 0,\"mode\": %d,\"alias\": NULL, \"valor\": NULL}\n", action);
                        return result;
                    }
                    break;
                }
        case 2:
        {
            // get memoria
            char result[10000];
            sprintf(result, "{\"code\": 1,\"mode\": %d,\"alias\": \"mem%d\", \"valor\": \"%s\", \"address\": \"%p\"}\n", action, r, memoria[r].valor, &memoria[r].valor);
            return result;
            
            break;
        }
        default:
        {break;}
    }
    return "";
}
char *getMemoria(registro *memoria, int intpos){
    return memoria[intpos].valor;
}


void allocateMemory(){
    int MAX_MEMORY = 61439;

    memoria = calloc(MAX_MEMORY,sizeof(registro));
    for (int i = 0;i<61439; i++){
        char hex[5];
        sprintf(hex, "%004x", getRandom(0, MAX_MEMORY));
        memoria[i] = setSingleValue(memoria[i], hex);
    }
    printf("Memoria asignada\n");
}
char *getR(int r){ // action = 0
    int action = 0;
    return mainProgress(action, r, "");
}
int getNumber(){
    return 1;
}
char *setR(int r, char str[4]){ // action = 1
    int action = 1;
    return mainProgress(action, r, str);
}
char *getMem(int r){ // action = 2
    int action = 2;
    return mainProgress(action, r, "");
}
