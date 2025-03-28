#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cstdlib>
#include <ctime>

// Определение структуры DataStruct
struct DataStruct {
    int key1;
    int key2;
    std::string str;
} ;

// Функция для генерации случайного числа в диапазоне [min, max]
int getRandomNumber(int min, int max) {
    return min + rand() % (max - min + 1);
}

// Функция для вывода вектора на печать
void printVector(const std::vector<DataStruct>& vec) {
    for (const auto& data : vec) {
        std::cout << "key1: " << data.key1 << ", key2: " << data.key2 << ", str: " << data.str << std::endl;
    }
    std::cout << "-----------------------------" << std::endl;
}

// Функция для сравнения двух структур DataStruct
bool compareDataStruct(const DataStruct& a, const DataStruct& b) {
    if (a.key1 != b.key1) {
        return a.key1 < b.key1;
    } else if (a.key2 != b.key2) {
        return a.key2 < b.key2;
    } else {
        return a.str.length() < b.str.length();
    }
}

int main() {
    // Инициализация генератора случайных чисел
    srand(static_cast<unsigned int>(time(0)));

    // Таблица строк для заполнения поля str
    std::vector<std::string> strTable = {
        "apple", "banana", "cherry", "date", "elderberry",
        "fig", "grape", "honeydew", "kiwi", "lemon"
    };

    // Создание вектора структур DataStruct
    std::vector<DataStruct> dataVector;

    // Заполнение вектора случайными данными
    for (int i = 0; i < 10; ++i) {
        DataStruct data;
        data.key1 = getRandomNumber(-5, 5);
        data.key2 = getRandomNumber(-5, 5);
        data.str = strTable[getRandomNumber(0, 9)];
        dataVector.push_back(data);
    }

    // Вывод исходного вектора на печать
    std::cout << "Original vector:" << std::endl;
    printVector(dataVector);

    // Сортировка вектора по заданным критериям
    std::sort(dataVector.begin(), dataVector.end(), compareDataStruct);

    // Вывод отсортированного вектора на печать
    std::cout << "Sorted vector:" << std::endl;
    printVector(dataVector);

    return 0;
}