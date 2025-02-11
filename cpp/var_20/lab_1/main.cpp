// Вариант 20. Сусликов А.В. группа 30022

//Напишите функцию, выполняющую действие в соответствии с вашим вариантом. Напишите
//функцию main, в которой примените вашу функцию для нескольких массивов :
//- Для встроенных массивов, количество и значения элементов которых заданы при
//инициализации.Создайте несколько массивов, чтобы протестировать различные случаи.
//- Для массива, размещённого в динамической памяти, количество элементов которого
//должно быть введено с клавиатуры, а значения элементов сгенерированы случайно.

// Задание: В массиве целых чисел найти максимальный среди четных элементов
#include <iostream>
#include <cmath>

int GetMaxEven(const int* arr, const int size) {
	if (arr == nullptr || size == 0) {
		return 0;
	}
	int max = INT32_MIN;
	
	for (int i = 1; i < size; i++) {
		if ( (arr[i] % 2 == 0) && (arr[i] > max)) {
			max = arr[i];
		}
	}
	if (max == INT32_MIN)
		max = -1;
	return max;
}

void PaintArr(const int* arr, const int size) {
	std::cout << "Mass: ";
	if (arr == nullptr) {
		std::cout << '\n';
		return;
	}
	for (int i = 0; i < size; i++)
		std::cout << arr[i] << ' ';
	std::cout << '\n';

}

int main()
{
	const int SIZE = 5;
	int mass[SIZE]  { 6, 4, 2, -2, 9 };
	int mass2[SIZE] { -11, -11, -13, -3, -1 };
	
	int nullMass[SIZE] {0, 0, 0, 0, 0};
	int dinamicSize = 0;
	std::cout << "Write dinamic array size: ";
	std::cin >> dinamicSize;
	int* pmass = new int[dinamicSize];
	for (int i = 0; i < dinamicSize; i++)
		pmass[i] = std::rand();
	int* pNullMass = nullptr;

	PaintArr(mass, SIZE);
	std::cout << "Max even: "
		      << GetMaxEven(mass, SIZE) << '\n';

	PaintArr(mass2, SIZE);
	std::cout << "Max even: "
		      << GetMaxEven(mass2, SIZE) << '\n';

	PaintArr(pmass, dinamicSize);
	std::cout << "Max even: "
		      << GetMaxEven(pmass, SIZE) << '\n';

	PaintArr(nullMass, SIZE);
	std::cout << "Max even: "
		<< GetMaxEven(nullMass, SIZE) << '\n';

	PaintArr(pNullMass, SIZE);
	std::cout << "Max even: "
		<< GetMaxEven(pNullMass, SIZE) << '\n';

	return 0;
}
