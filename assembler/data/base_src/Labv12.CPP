/*               Структура растрового ВМР  файла
		Лабораторная работа 12
*/
#include <stdio.h>
#include <conio.h>

typedef unsigned int WORD;
typedef unsigned long DWORD;
struct BITMAPFILEHEADER {
		  WORD    bfType;
		  DWORD   bfSize; // Размер файла
		  WORD    bfReserved1;
		  WORD    bfReserved2;
		  DWORD   bfOffBits;
};
struct BITMAPINFOHEADER{
	DWORD  biSize;
	DWORD  biWidth;
	DWORD  biHeight;
	WORD   biPlanes;
	WORD   biBitCount;     // Количество бит в пикселе
	DWORD  biCompression;
	DWORD  biSizeImage;
	DWORD  biXPelsPerMeter;
	DWORD  biYPelsPerMeter;
	DWORD  biClrUsed;
	DWORD  biClrImportant;
};


void main(int c,char **a)
{
	FILE *in, *out;
	highvideo();
BITMAPFILEHEADER bfh;
BITMAPINFOHEADER bih;
/* FILE *po;
if(argc==0)  return 0;
if(argc==2) { mode=257;} else mode=atoi(argv[2]);
po=fopen(argv[1],"rb");
fread(&bfh,14,1,po);
fread(&bih,40,1,po);
if(bih.biBitCount!=8) return 1;
if(bih.biClrUsed==0){ cmax=256;   }
else cmax=bih.biClrUsed;
*/
cputs("(c) Rex Software'99  Bmp Universal Invertor v1.0");
normvideo();
cputs("");

	int n,bpp;
		if (c!=2)
	{
		puts("\nNeeds some bmps");
		return ;
	}

	  in = fopen(a[1], "rb");
	if ((out = fopen("inversed.bmp", "wb"))== NULL)
	{
	puts("Cannot open output file");   return ;
	}
	cprintf("\n");
	cputs("Please wait");
	for (int i=0;i<54;i++) {
					int c=fgetc(in);
					fputc(c,out);
	if (i==28)  bpp=c;}
	if (bpp==8)
	{
	for (i=0;i<1024;i++) fputc(255-fgetc(in),out);

	while (!feof(in)) fputc(fgetc(in),out);
	}
	if (bpp==24)
	{	for (int i=0;i<54;i++) fputc(fgetc(in),out);
	while (!feof(in)) fputc(255-fgetc(in),out);}

	fcloseall();
	printf("\n%s is %d bit-per-pixel color depth bitmap\n",a[1],bpp);
	puts("Successsfully retrieved to Inversed.bmp");
}
/* Задание
1. Напишите программу бинаризации изображения.
2. Напишите программу тестирования входного файла (8 - 24 бита)
обязательно используйте структуры для тестирования.
*/