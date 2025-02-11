// ЗАДАНИЕ
// Напишите программу пересылки данных из одного массива в 
// другой в модели памяти LARGE. Обязательно используйте команду LDS 
// (LES). Укажите, как используются регистры.


#include <stdio.h>
#include <conio.h>

char A[10]={2,1,2,3,4,5,6,7,8,9};
char B[10]={0,0,0,0,0,0,0,0,0,0};

int main (void)
{

    clrscr();

    char* pA = A;
    char* pB = B;

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

   asm {
        cld
        mov cx, n; // Загружаем размер массива в cx
        lds si, [pA]; // Загрузка сегмента и смещения A в DS:SI
        les di, [pB]; // Загрузка сегмента и смещения B в ES:DI
        rep movsb;
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