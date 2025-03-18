#include <algorithm>
#include <iostream>
#include <vector>

#include "statisticcollector.h"

std::vector<int> generateRandomSequence(int size, int min_val, int max_val) {
    std::vector<int> sequence;
    std::srand(static_cast<unsigned>(std::time(nullptr))); // Инициализация генератора случайных чисел
    for (int i = 0; i < size; ++i) {
        int random_value = min_val + (std::rand() % (max_val - min_val + 1));
        sequence.push_back(random_value);
    }
    return sequence;
}

int main()
{
    // Генерация случайной последовательности
    int sequence_size = 20; // Размер последовательности
    int min_val = -500;     // Минимальное значение
    int max_val = 500;      // Максимальное значение
    std::vector<int> sequence = generateRandomSequence(sequence_size, min_val, max_val);

    // Вывод сгенерированной последовательности
    std::cout << "Generated sequence: ";
    for (int num : sequence) {
        std::cout << num << " ";
    }
    std::cout << "\n";

    // Создание экземпляра функтора
    StatisticCollector collector;

    // Применение функтора к последовательности
    collector = std::for_each(sequence.begin(), sequence.end(), collector);

    // Вывод собранной статистики
    std::cout << "Statistics:\n";
    std::cout << "Max value: " << collector.getMax_val() << "\n";
    std::cout << "Min value: " << collector.getMin_val() << "\n";
    std::cout << "Average value: " << collector.average() << "\n";
    std::cout << "Positive numbers count: " << collector.getPositive_count() << "\n";
    std::cout << "Negative numbers count: " << collector.getNegative_count() << "\n";
    std::cout << "Odd elements sum: " << collector.getOdd_sum() << "\n";
    std::cout << "Even elements sum: " << collector.getEven_sum() << "\n";
    std::cout << "First and last elements are equal: "
              << (collector.isEqualFirstLast() ? "Yes" : "No") << "\n";

    return 0;
}
