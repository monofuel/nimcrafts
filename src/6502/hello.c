#include <stdio.h>
#include <stdlib.h>

// https://cc65.github.io/doc/intro.html#ss1.1
// https://cc65.github.io/doc/intro.html#ss1.1

extern const char text[]; /* In text.s */
int main(void) {
    printf("%s\n",text);
    return EXIT_SUCCESS;
}