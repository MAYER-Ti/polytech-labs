// Вариант 13. Лютов А.В. группа 30022

//Напишите функцию, выполняющую действие в соответствии с вашим вариантом. Напишите
//функцию main, в которой примените вашу функцию для нескольких массивов :
//- Для встроенных массивов, количество и значения элементов которых заданы при
//инициализации.Создайте несколько массивов, чтобы протестировать различные случаи.
//- Для массива, размещённого в динамической памяти, количество элементов которого
//должно быть введено с клавиатуры, а значения элементов сгенерированы случайно.

// Задание: В массиве целых чисел определить наибольшую длину монотонно убывающего фрагмента
// последовательности(то есть такого фрагмента, где каждый элемент меньше предыдущего)
// Примечание:

#include <iostream>

int GetLongestDecreasingSequence(const int* arr, const int size) {
    if (arr == nullptr || size == 0) {
        return 0;
    }
    if (size == 1) {
        return 1;
    }
    int lastlong = 0;
    int currentLong = 1;
    for (int i = 1; i < size; i++) {
        if (arr[i] < arr[i - 1]) {
            currentLong++;
        }
        else {
            lastlong = (currentLong > lastlong) ? (currentLong) : (lastlong);
            currentLong = 1;
        }
    }
    lastlong = (currentLong > lastlong) ? (currentLong) : (lastlong);
    return lastlong;
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
	int mass[SIZE]  { 5, 4, 3, 10, 9 };
	int mass2[SIZE] { 1, 3, 3, 3, 2 };
	int dinamicSize = 0;
	std::cout << "Write dinamic array size: ";
	std::cin >> dinamicSize;
	int* pmass = new int[dinamicSize];
	for (int i = 0; i < dinamicSize; i++)
		pmass[i] = std::rand();
	int nullMass[SIZE] {0, 0, 0, 0, 0};
	int* pNullMass = nullptr;

	PaintArr(mass, SIZE);
	std::cout << "Longest decreasing sequence: "
		      << GetLongestDecreasingSequence(mass, SIZE) << '\n';

	PaintArr(mass2, SIZE);
	std::cout << "Longest decreasing sequence: "
		      << GetLongestDecreasingSequence(mass2, SIZE) << '\n';

	PaintArr(pmass, SIZE);
	std::cout << "Longest decreasing sequence: "
		      << GetLongestDecreasingSequence(pmass, dinamicSize) << '\n';

	PaintArr(nullMass, SIZE);
	std::cout << "Longest decreasing sequence: "
		<< GetLongestDecreasingSequence(nullMass, SIZE) << '\n';

	PaintArr(pNullMass, SIZE);
	std::cout << "Longest decreasing sequence: "
		<< GetLongestDecreasingSequence(pNullMass, SIZE) << '\n';

	return 0;
}
