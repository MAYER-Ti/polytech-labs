/*                         LAB-7
		������ୠ� ࠡ�� �� ⥬�
		  "��᫠ ᯫ����饩 ����⮩"

	 */
#include<stdio.h>
#include<dos.h>
#include<iostream.h>
#include <conio.h>
#include <float.h>

void main(void)
{ int aa;
// ����樨 � ������饩 ����⮩ �� �஢�� ��
  float bb,ad;
  aa=1; bb=5.0;ad=3.1;
  bb=aa;
cout<<"\n Ci  "<<bb;
// cin>>bb;
getch();

// ����樨 � ������饩 ����⮩ �� �஢�� ��ᥬ����
asm {   finit
	fld ad
	fld bb
	fadd
	fstp bb
}
cout<<"   Acc  "<<bb;
getch();

  return;
// �������
// 1 �믮���� ����樨 ��� �᫠�� � �� �� �஢�� ��
// 2 ������ �ணࠬ�� �� ��� (� �ਬ��): ������ � ������� �� �᫠,
// ����㧨� �� � ॣ����� FPU, ���㬬����, �뢥��� १����
// ��᫥��� ࠡ��� FPU � TD. ��� �ᯮ������� ॣ����� FPU ?
// 3 ������ � FPU ���᫮ (NaN), ������� ��� � TD. �맮���
// ���뢠��� �� �⮬� �ᮡ��� ����.
// 4 ������ �� ��� ��ࠦ���� ��� �ᥫ � ��: x=x/y. �஢���� � TD
  }
