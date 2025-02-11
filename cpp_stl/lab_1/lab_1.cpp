// Лютов А.В. 30022
// Задания
// 1) Напишите алгоритм сортировки (любой простейший) содержимого вектора целых чисел, используя оператор operator[].
// 2) Напишите алгоритм сортировки (любой простейший) содержимого вектора целых чисел, используя метод at().
// 3) Напишите алгоритм сортировки (любой простейший) содержимого вектора целых чисел, 
// используя для доступа к содержимому вектора только итераторы. Для работы с итераторами допустимо использовать 
// только операторы получения текущего элемента и перехода в следующему 
// (подсказка, можно сохранять копию итератора указывающего на некоторый элемент). 
// 4) Прочитайте во встроенный массив С содержимое текстового файлы, скопируйте данные в вектор одной строкой кода (без циклов и алгоритмов STL)
// 5) Напишите программу, сохраняющую в векторе числа, полученные из стандартного ввода (окончанием ввода является число 0). 
// Удалите все элементы, которые делятся на 2 (не используете стандартные алгоритмы STL), если последнее число 1. Если последнее число 2, 
// добавьте после каждого числа которое делится на 3 три единицы.
// 6) Напишите функцию void fillRandom(double* array, int size) заполняющую массив случайными значениями в интервале от -1.0 до 1.0. 
// Заполните с помощью заданной функции вектора размером 5,10,25,50,100 и отсортируйте его содержимое 
// (с помощью любого разработанного ранее алгоритма модифицированного для сортировки действительных чисел) 
#include <iostream>
#include <vector>
#include <random>
#include <fstream>
#include <algorithm> // Для std::sort
#include <chrono>

// 1) Сортировка пузырьком с использованием operator[]
void bubbleSortUsingOperator(std::vector<int>& vec) {
    for (size_t i = 0; i < vec.size() - 1; ++i) {
        for (size_t j = 0; j < vec.size() - i - 1; ++j) {
            if (vec[j] > vec[j + 1]) {
                std::swap(vec[j], vec[j + 1]);
            }
        }
    }
}

// 2) Сортировка пузырьком с использованием at()
void bubbleSortUsingAt(std::vector<int>& vec) {
    for (size_t i = 0; i < vec.size() - 1; ++i) {
        for (size_t j = 0; j < vec.size() - i - 1; ++j) {
            if (vec.at(j) > vec.at(j + 1)) {
                int temp = vec.at(j);
                vec.at(j) = vec.at(j + 1);
                vec.at(j + 1) = temp;
            }
        }
    }
}

// 3) Сортировка пузырьком с использованием итераторов
void bubbleSortUsingIterators(std::vector<int>& vec) {
    for (auto i = vec.begin(); i != vec.end(); ++i) {
        for (auto j = vec.begin(); j != vec.end() - 1 - (i - vec.begin()); ++j) {
            auto next = j;
            ++next;
            if (*j > *next) {
                std::swap(*j, *next);
            }
        }
    }
}

// Чтение данных из файла
std::vector<int> readDataFromFile(const std::string& filename) {
    std::ifstream file(filename);
    std::vector<int> data;
    int number;
    while (file >> number) {
        data.push_back(number);
    }
    return data;
}

// 5) Обработка чисел согласно условию
void processNumbers(std::vector<int>& numbers) {
    if (numbers.empty()) return;
    
    int lastNum = numbers.back();
    
    if (lastNum == 1) {
        // Удаляем числа, которые делятся на 2
        for (size_t i = 0; i < numbers.size();) {
            if (numbers[i] % 2 == 0) {
                numbers.erase(numbers.begin() + i);
            } else {
                ++i;
            }
        }
    } else if (lastNum == 2) {
        // Добавляем три единицы после чисел, делящихся на 3
        for (size_t i = 0; i < numbers.size(); ++i) {
            if (numbers[i] % 3 == 0) {
                numbers.insert(numbers.begin() + i + 1, {1, 1, 1});
                i += 3;
            }
        }
    }
}

// Функция заполнения массива double случайными числами в интервале [-1.0, 1.0]
void fillRandom(double* array, int size) {
    if (array == nullptr || size <= 0) {
        std::cerr << "Ошибка: неверные параметры функции.\n";
        return;
    }

    // Инициализация генератора случайных чисел
    std::srand(static_cast<unsigned int>(std::time(nullptr)));

    for (int i = 0; i < size; ++i) {
        // Генерация случайного числа в диапазоне [0, RAND_MAX]
        double randomValue = static_cast<double>(std::rand()) / RAND_MAX; // Приведение к диапазону [0.0, 1.0]
        // Преобразование к диапазону [-1.0, 1.0]
        array[i] = (randomValue * 2.0) - 1.0;
    }
}
// Модифицированная сортировка пузырьком для double
void bubbleSortDouble(std::vector<double>& vec) {
    for (size_t i = 0; i < vec.size() - 1; ++i) {
        for (size_t j = 0; j < vec.size() - i - 1; ++j) {
            if (vec[j] > vec[j + 1]) {
                std::swap(vec[j], vec[j + 1]);
            }
        }
    }
}
int main() {
    setlocale(LC_ALL, "rus");

    // Чтение данных из файла
    std::vector<int> test_vector = readDataFromFile("..\\data.txt");
    if (test_vector.empty()) {
        std::cerr << "Файл 'data.txt' пуст или не удалось прочитать данные.\n";
        return 1;
    }

    // Создаем копии вектора для каждого теста
    auto vec1 = test_vector;
    auto vec2 = test_vector;
    auto vec3 = test_vector;
    auto vec_std = test_vector;

    // Замер для operator[]
    auto start = std::chrono::high_resolution_clock::now();
    bubbleSortUsingOperator(vec1);
    auto end = std::chrono::high_resolution_clock::now();
    std::cout << "Время сортировки с operator[]: "
        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000000.0
        << " сек.\n";

    // Замер для at()
    start = std::chrono::high_resolution_clock::now();
    bubbleSortUsingAt(vec2);
    end = std::chrono::high_resolution_clock::now();
    std::cout << "Время сортировки с at(): "
        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000000.0
        << " сек.\n";

    // Замер для итераторов
    start = std::chrono::high_resolution_clock::now();
    bubbleSortUsingIterators(vec3);
    end = std::chrono::high_resolution_clock::now();
    std::cout << "Время сортировки с итераторами: "
        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000000.0
        << " сек.\n";

    // Замер для std::sort
    start = std::chrono::high_resolution_clock::now();
    std::sort(vec_std.begin(), vec_std.end());
    end = std::chrono::high_resolution_clock::now();
    std::cout << "Время сортировки с std::sort: "
        << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() / 1000000.0
        << " сек.\n";

    // Тест задания 5
    std::vector<int> numbers;
    int num;
    std::cout << "Введите числа по заданию:\nУдалите все элементы, которые делятся на 2" <<
        ", если последнее число 1. Если последнее число 2, добавьте после" <<
        " каждого числа которое делится на 3 три единицы.\n (0 для завершения): ";
    while (std::cin >> num && num != 0) {
        numbers.push_back(num);
    }
    processNumbers(numbers);
    std::cout << "Вектор по заданию:\n";
    for (const auto& number : numbers) {
        std::cout << number << " ";
    }
    std::cout << "\n";
    // Тест задания 6
    const int sizes[] = { 5, 10, 25, 50, 100 };
    for (int size : sizes) {
        std::vector<double> vec(size);
        fillRandom(vec.data(), size);
        bubbleSortDouble(vec);
        std::cout << "\nОтсортированный массив размера " << size << ":\n";
        for (double val : vec) {
            std::cout << val << " ";
        }
        std::cout << "\n";
    }
    return 0;
}