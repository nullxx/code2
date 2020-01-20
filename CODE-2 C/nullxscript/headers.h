//
//  headers.h
//  CODE-2 C
//
//  Created by Jon Lara Trigo on 19/01/2020.
//  Copyright © 2020 Jon Lara Trigo. All rights reserved.
//

#ifndef headers_h
#define headers_h

#include <stdio.h>
#include <string.h>
#include "memoria.h"
#include <unistd.h> // sleep
#include <stdlib.h>
#include "tools.h"
char *getR(int r);
char *setR(int r, char str[4]);
char *getMem(int r);
void allocateMemory(void);
#endif /* headers_h */
