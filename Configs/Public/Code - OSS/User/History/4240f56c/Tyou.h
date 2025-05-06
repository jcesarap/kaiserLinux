#ifndef _BIBTELA
#define _BIBTELA
// Wrap library dependencies, define function prototypes

// The condition above will make sure that libraries are only included if they weren't already

/*
* Includes
*/
#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>
#include <unistd.h>
#include <locale.h>
#include <string.h>
#include <wchar.h>

/*
* Function prototypes
*/
void init_screen(int x, int y);
void end_screen(void);
void clear_screen(void);
void xygoto(int x, int y);
int xyprint(int x, int y, const char* str);

#endif
