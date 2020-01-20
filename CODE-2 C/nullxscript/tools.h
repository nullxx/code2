//
//  tools.h
//  nullxscript
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//
#include <time.h>

int isEntryValid(int entry, int mode){
    int NUM_OF_REG = 26;
    if (mode < 2){
        if (entry >= 0 && entry <= NUM_OF_REG){
            return 1;
        }else{
            return 0;
        }
    }else{
       if (entry >= 0 && entry <= 61439){
            return 1;
        }else{
            return 0;
        }
    }
}
int isCharLengthValid(char valor[]){
    if (strlen(valor) == 4){
        return 1;
    }else{
        return 0;
    }
}

int getRandom(int min, int max){
    int number = min + rand() % (max - min);
    return number;
}

