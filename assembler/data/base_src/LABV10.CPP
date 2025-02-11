//      "Обмен IBM PC с клавиатурой"
//             Labv10

#include <iostream.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <bios.h>
#define Port8042 0x60

long far * pTime=(long far*)0x46C;   // Указатель на счетчик тиков

// Определим указатели начала и конца буфера

int far * pHeadPtr=(int far  *)0x41A;   // Указатель на указатель головы буф.кл.
int far * pTailPtr=(int far  *)0x41C;   // Указатель на указатель хвоста буф.кл.
unsigned char far * pBuf;

void main()
{
// 3адание N1.
  clrscr();

  cout << "\n 3адание N1:\n";
  cout << "\n Нажимайте клавиши для получения кодов!";
  cout << "\n Пробел - идем дальше.\n";
  char cScan,cAsci;
  int iAdres;
  do
  {
   // Загрузить пару регистров, например ds:si значением 0x40:0x1A
	asm{
		push ds 	//
		push si         //  Сохранили регистры
		push di         //
		mov ax,0x40     //
		mov ds,ax       //   Загрузили сегмент
		mov si,0x1A     // и указатели на голову
		mov di,0x1C     // и на хвост
		}
	wait_kbd:
	asm{
	   mov ax,[si]     //   Сравниваем указатели -
	   cmp ax,[di]     // т.е. ждем нажатия
	   je wait_kbd
	// Загрузить регистр di значением 0x1C
	// Сравнить указатели
	// Прочитать указатель
	   mov si,[si]
	   }
	iAdres=_SI;
	// Прочитать значение из буфера
	asm mov ax,[si]
	// Теперь _AL и _AH содержат скан-код и ASCII-код
	asm pop di
	asm pop si
	asm pop ds
	cScan=_AH;
	cAsci=_AL;
	printf("Адрес = %x   Скан = %d      ASCII = %d \n",iAdres,cScan,cAsci);
  } while(getch() != 32);
  cout << "\n Конец первого задания. Press any key...\n";
  getch();

       delay(1000);
	 asm in al,0x60
	 cScan=0; // ??????
	 printf(" Скан = %x \n",cScan);
//	 goto met;
//
}
// Задание
// 1 Разберите представленную программу
//  Определите отличие ASCII кодов: основных и служебных клавиш
// 2 Напишите мини программу циклического чтения скан кодов из порта 60
//  Определите отличие скан кодов: нажатия и отпускания клавиши
