/* Lab:  Ass, BIOS  and  Ci functions
  Шаблон программы для работы с видеосистемой   Labv9
  Графические режимы
   */
#include <graphics.h>
#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

#include <time.h>;

union REGS r;

void main()
{
// Устан номера видеорежима
 int j,i,ii,color=0;
   r.h.ah=0x0;
   r.h.al=0x13;
//_asm int 0x10;
     int86(0x10,&r,&r);
 // Вывод цветного клина
   for( j =1 ; j <319  ; j ++)
     { color=color+1;
	 _AH=0x0c;
	 _AL=color;
	   if(color==256) color=0;
	 _BH=0;
	 _DX=50;
	 _CX=j;
    geninterrupt(0x10);
     }
   getch();

//Перепрограммирование таблицы палитры
  ii=clock();
   for( i = 0 ; i < 255 ; i++)
  { _AH=0x10;
    _AL=0x10;
    _BX=i; // Номер регистра
    _CH=i; /* G */
    _CL=i; /* B */
    _DH=i; /* R */
    geninterrupt(0x10);
  }		/*  */
   color=256;
    i=clock()-ii;

// Вывод полутонового клина
    for( j =1 ; j <319  ; j ++)  /*  */
  { color=color-1;
  _AH=0x0c;
  _AL=color;
  if(color==0) color=256;
  _BH=0;
  _DX=100; // строка вывода
  _CX=j;
    geninterrupt(0x10);
  }
//     printf("Время перепрограммирования табл палитр : %d",i);
     getch();

// Задания
// 1  Подкрасьте полутоновой клин красным цветом
// 2  Выведите клин в режиме прямой работы с видео памятью
// (напишите Асс программу вывода возрастающ кода, начиная с a0000)
// 3  Измерьте время вывода и перепрограммир табл палитры используя i=clock()
// 4  Придумайте абстрактную анимацию, выведя несколько
//    цветовых клиньев и циклически перепрограммируя табл палитры
  return;
}