//              Лабораторная Работа Lab 4
//            ТАЙМЕР. Измерение времени. Мышь
//


#include<iostream.h>
#include<conio.h>
#include<stdio.h>

void main()
{
 long int cl2,cl1,c1,c2;
 unsigned long int t1,t2,t3;

// Изменение константы счетчика
/* asm{
     mov ax,00110110B  // 00 11 011 0
     out 43h,ax
     mov ax,0000000000000000B
     out 40h,al
     mov al,ah
     out 40h,al
    }
 */

 // Измерение времени выполнения тестовой программы 1
//  в тиках (в прерываниях от 0-го канала таймера)
// Счетчик тиков ячейка 46С - младший байт первый
 asm{
  mov ax,0x46
  mov es,ax
  mov bx,0xC
  mov ax,[es:bx]
  mov cx,[es:(bx+2)]
 }
// Запомните начальное  значение младшее и старшее ???
// cl2=  ; cl1=  ;
 c1=cl2+cl1*0x10000;

 //Тестовая программа 1
  asm mov cx,1000
  met1: asm {
	     push cx
	     mov cx,1000
	     }
  met2: asm {
	     loop met2
	     pop cx
	     loop met1
	     }

//
 asm{
  mov ax,0x46
  mov es,ax
  mov bx,0xC
  mov ax,[es:bx]
  mov cx,[es:(bx+2)]
 }
// Запомните конечное значение  ???
// cl2=_AX; cl1=   ;
// Длинное целое -
c2=cl2+cl1*0x10000;

// clrscr();
// printf("\nПервое - %d\n",c1);
// printf("Второе - %d\n",c2);
 cout<<"\nВремя выполнения тестовой программы 1\n";
 cout<<"COUNTs: "<<c2-c1<<"\n";
  printf("\n   Сколько миллисекунд ??");
  getch();

// Измерение времени выполнения тестовой программы
//  по содержимому регистра таймера
//   Порт 43h - порт управления таймером
//   Порт 40h - порт таймера

 asm{
  mov ax,00000110B    // 00 00 011 0
  out 43h,ax  // Читаем младший, потом старший
  in al,40h
//  mov bl,al
  in al,40h
//  mov ah,al
//  mov al,bl
 }
 t1=_AX;


 //Тестовая программа 2
  asm mov cx,1
  met11: asm {
	     push cx
	     mov cx,1000
	     }
  met22: asm {
	     loop met22
	     pop cx
	     loop met11
	     }

  asm{
  mov ax,00000110B    // 00 00 011 0
  out 43h,ax  // Читаем младший, потом старший
  in al,40h
//  mov bl,al
  in al,40h
//  mov ah,al
//  mov al,bl
 }
 t2=_AX;
 t3=t1;     // ????

 clrscr();
    printf("\nПервое - %d \n",t1);
    printf("Второе - %d\n",t2);
 cout<<"\nВремя выполнения тестовой программы 2\n";
 printf("%x\n",t3);
 cout<<"CLOCKs: "<<t3<<"\n";
   printf("\n   Сколько микросекунд ??");
   getch();

// Задания
// 1 Определите времена работы тестовых программ 1 и 2
// 2 Перепрограммируйте таймер и измерьте время раб прог1 более точно
// 3 Определите время между двумя нажатиями на кнопку мыши (или клавиатуры)

//Эта процедура считывает положение курсора мыши и признак нажатия
//на клавишу.  Прочитайте описание драйвера мыши и программу Asmous.cpp.

void ReadMouse ()
{
  asm mov ax, 0x3
  asm int 0x33
  asm mov MouseB, bx
  asm mov MouseX, cx
  asm mov MouseY, dx
}


}