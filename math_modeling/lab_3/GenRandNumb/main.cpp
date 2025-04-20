#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>
#include <fstream>

#include "normaldistributiongenerator.h"

// Функция для записи вектора чисел в файл (по одному значению на строку)
void write_to_file(const std::vector<double>& values, const std::string& filename) {
    std::ofstream outfile(filename);
    if (!outfile) {
        std::cerr << "Ошибка открытия файла " << filename << " для записи" << std::endl;
        return;
    }

    outfile << std::fixed << std::setprecision(15);
    for (const auto& value : values) {
        outfile << value << '\n';
    }

    outfile.close();
}

void test_builtin_rng() {
    const int n = 100000;
    std::vector<double> numbers(n);

    // Инициализация генератора случайных чисел
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    // Генерация чисел и вычисление суммы
    double sum = 0.0;
    for (int i = 0; i < n; ++i) {
        numbers[i] = dis(gen);
        sum += numbers[i];
    }

    // Запись в файл
    write_to_file(numbers, "builtin_rng_values.txt");

    // Вычисление мат. ожидания
    double m_r = sum / n;

    // Вычисление дисперсии и СКО
    double variance = 0.0;
    for (int i = 0; i < n; ++i) {
        variance += (numbers[i] - m_r) * (numbers[i] - m_r);
    }
    variance /= n;
    double sigma_r = std::sqrt(variance);

    // Теоретические значения
    const double theoretical_m = 0.5;
    const double theoretical_variance = 1.0 / 12.0;
    const double theoretical_sigma = std::sqrt(theoretical_variance);

    // Вывод результатов
    std::cout << "=== Проверка встроенного ГСЧ ===" << std::endl;
    std::cout << std::fixed << std::setprecision(6);
    std::cout << "Количество чисел: " << n << std::endl;
    std::cout << "Вычисленное мат. ожидание: " << m_r << " (теоретическое: " << theoretical_m << ")" << std::endl;
    std::cout << "Вычисленная дисперсия: " << variance << " (теоретическая: " << theoretical_variance << ")" << std::endl;
    std::cout << "Вычисленное СКО: " << sigma_r << " (теоретическое: " << theoretical_sigma << ")" << std::endl;
}

void test_custom_rng() {
    const int n = 100000;
    const double mx = 0.0;
    const double max_y_table = 40.0; // 15.6204
    const double sigma_x = 0.05 * max_y_table; // 0.05 * 15.6204 = 0.78102

    NormalDistributionGenerator generator;
    std::vector<double> numbers(n);

    // Генерация чисел и вычисление суммы
    double sum = 0.0;
    for (int i = 0; i < n; ++i) {
        numbers[i] = generator.generate(mx, sigma_x);
        sum += numbers[i];
    }

    // Запись в файл
    write_to_file(numbers, "custom_rng_values.txt");

    // Вычисление мат. ожидания
    double m_x = sum / n;

    // Вычисление дисперсии и СКО
    double variance_x = 0.0;
    for (int i = 0; i < n; ++i) {
        variance_x += (numbers[i] - m_x) * (numbers[i] - m_x);
    }
    variance_x /= n;
    double sigma_x_calculated = std::sqrt(variance_x);

    // Теоретические значения
    const double theoretical_mx = mx;
    const double theoretical_sigma_x = sigma_x;
    const double theoretical_variance_x = sigma_x * sigma_x;

    // Вывод результатов
    std::cout << "\n=== Проверка собственного ГСЧ ===" << std::endl;
    std::cout << std::fixed << std::setprecision(6);
    std::cout << "Количество чисел: " << n << std::endl;
    std::cout << "Параметры распределения: mx = " << mx << ", σx = " << sigma_x << std::endl;
    std::cout << "Вычисленное мат. ожидание: " << m_x << " (теоретическое: " << theoretical_mx << ")" << std::endl;
    std::cout << "Вычисленная дисперсия: " << variance_x << " (теоретическая: " << theoretical_variance_x << ")" << std::endl;
    std::cout << "Вычисленное СКО: " << sigma_x_calculated << " (теоретическое: " << theoretical_sigma_x << ")" << std::endl;
}


int main()
{
    // Проверка встроенного ГСЧ
    test_builtin_rng();

    // Тестирование собственного ГСЧ
    test_custom_rng();

    return 0;
}
