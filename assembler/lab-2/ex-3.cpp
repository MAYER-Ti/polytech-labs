// ЗАДАНИЕ
// Напишите программу пересылки данных из одного массива в 
// другой с одной из строковых команд: LODS, MOVS, STOS с 
// использованием префикса повторения REP и подготовки нужных 
// регистров
#include <stdio.h>
#include <conio.h>

char A[10]={2,1,2,3,4,5,6,7,8,9};
char B[10]={0,0,0,0,0,0,0,0,0,0};



int main (void)
{ 
    clrscr();

    int n = 10;
    int i = 0;

    printf ("\nA:");
    for (i=0;i<n; i++) {
        printf (" %d", A[i]);
    } 
    printf ("\nB:");
    for (i=0;i<n; i++) {
        printf (" %d", B[i]);
    }

    printf ("\nmove A=>B");

    // Пересылка данных из A в B с помощью MOVSB
    asm {
        cld;
        mov cx, n       // Количество пересылаемых байтов (10 элементов)
        lea si, A        // Загружаем адрес массива A в регистр SI
        lea di, B        // Загружаем адрес массива B в регистр DI
       // mov cx, 1
        rep movsb        // Пересылаем cx байтов из A в B
    }
    printf ("\nA:");
    for (i=0;i<n; i++) {
        printf (" %d", A[i]);
    } 
    printf ("\nB:");
    for (i=0;i<n; i++) {
        printf (" %d", B[i]);
    }

    getch();
    return 0;
};