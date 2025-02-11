/*                       LAB6
		Лабораторная работа по теме
		  "Программные прерывания"


При вызове функции - прерывания из СИ, используется INT.
В связи с этим стек заполняется несколько иначе.
В стеке сохраняются значения IP, СS (сегмент кода),от куда вызывается
прерывание, и флаги.
Выход из INT осуществляется с помощью IRet,которая вынимает из стека
все старые регистров CS, IP и флагов.
Так же при вызове прерывания,флажок прерывания i и t
устанавливается в 0, что запрещает вызов любых других прерываний,
а также запрещает трассировку.
*/
#include<stdio.h>
#include<dos.h>
#include<iostream.h>
#include <conio.h>

void interrupt (*old)(...);     // здесь будем сохранять старый вектор
void interrupt outProc(...)     // а это наш обработчик
{
  cout<<"Call procedure from interrupt";
  getch();

}
void interrupt func_div_zero(...){
  cout<<"Error div zero\n";
  cout<<"Skip\n";
  asm{
    mov ax, [bp+18]
    add ax, 2 // Перепригиваем на следующую инструкцию

    mov [bp+18], ax
  }
  cout<<"Skipped instruction\n";
}

void main(void)
{
  clrscr();
  //call interrupt for display message
  // Вызов прерывания с помощью geninterrupt;
  // Код свободного прерывания 0xf0
  old=getvect(0xf0);
  disable();
  setvect(0xf0,outProc);
  enable();

  geninterrupt(0xf0);

  setvect(0xf0,old);



  // Вызов прерывания деления на 0
  // Код прерывания деления на 0 это 0x00
  old=getvect(0x00);
  disable();

  setvect(0x00,func_div_zero);
  enable();

  int a = 1;
  a=a/0;

  setvect(0x00,old);
  getch();
  cout<<"a = "<<a<<"\n";
  return;
  }
