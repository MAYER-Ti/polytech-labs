#include <iostream>
#include <conio.h>

#include <immintrin.h>
#include <xmmintrin.h>
#include <mmintrin.h>

#include <dvec.h>

int main(void) {

	//// MMX ////

	// для mmx - 8 чисел по байту
	char amm[8] = {1, 1, 1, 1, 1, 1, 1, 1};
	char bmm[8] = {2, 2, 2, 2, 2, 2, 2, 2};

	// mmx работает с 64-x битными регистрами
	_asm {
		movq	mm0, amm
		movq	mm1, bmm
		paddb	mm0, mm1
		movq	amm, mm0
	}

	//// SSE ////

	// для sse - 4 числа по 4 байта
	float a[4] = { 1.0, 2.0, 3.0, 4.0 };
	float b[4] = { 5.0, 6.0, 7.0, 8.0 };
	float c[4];

	// Тоже самое, только с 128-ми битными регистрами
	_asm {
		//sse
		movups	xmm0, a
		movups	xmm1, b
		addps	xmm0, xmm1
		movups	c, xmm0
	}

	//// SSE2 ////

	double f[2] = { 16, 4 };
	_asm {
		//sse2
		movups xmm1, f
		sqrtpd xmm0, xmm1
		movups f, xmm0
	}

	//// AVX ////

	char a128[16] = { 1, 18, 3, 19, 5, 21, 7, 23, 9, 25, 11, 27, 13, 29, 15, 31 };
	char b128[16] = { 17, 2, 19, 4, 21, 6, 23, 8, 25, 10, 27, 12, 29, 14, 31, 16 };
	_asm {
		movups	xmm0, a128
		movups	xmm1, b128
		pminub	xmm0, xmm1 
		movups	a128, xmm0
	}


	//// Библиотека intr ////

	__m256 ai = { 3.0, 4.0, 5.0, 4.0, 4.0, 5.0, 7.0, 5.0 };
	__m256 bi = { 5.0, 7.0, 5.0, 8.0, 4.0, 4.0, 5.0, 7.0 };

	__m256 hai = _mm256_hadd_ps(ai, ai);
	__m256 hbi = _mm256_hadd_ps(bi, bi);


	//// С помощью dvec ////

	//Внутри этого класса вектора используются функции библиотеки intr
	F32vec4 vecA = { 3.0, 4.0, 5.0, 4.0 };
	F32vec4 vecB = { 5.0, 7.0, 5.0, 8.0 };

	F32vec4 vecC = vecA + vecB;

	
	//getch();
	return 0;
}