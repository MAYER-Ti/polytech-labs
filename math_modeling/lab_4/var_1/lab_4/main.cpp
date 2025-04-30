#include "genrandnumb.h"
#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <iterator>
#include <functional>
#include <float.h>

std::vector<double> AilerCalc(double x, double k, double a1, double a2, double b1, double b2, int nIter = 580, double h = 0.05) {
    std::vector<double> res(nIter);
    double z1 = 0;
    double z2 = 0;
    double z3 = 0;

    double dz1 = 0;
    double dz2 = 0;
    double dz3 = 0;

    for (int i = 1; i < nIter; ++i) {
        dz1 = z1 + h * z2;
        dz2 = z2 + h * z3;
        dz3 = z3 + h * ((x - z1 - (2 * b1 + b2) * z2 - (2 * b1 * b2 + b1 * b1) * z3) / (b2 * b1 * b1));

        res[i] = { k * z1 - a2 * k * z2 + a1 * k * z2 - a1 * a2 * k * z3 };

        z1 = dz1;
        z2 = dz2;
        z3 = dz3;
    }
    return res;
}

//!
//! \brief generateDefaultSequence
//! Процедура использовалась для записи Y_e в файл
//! Зашумленные данные
void generateDefaultSequence() {
    const int x = 5;
    const int k = 3;
    const int a1 = 5;
    const int a2 = 3;
    const int b1 = 3;
    const int b2 = 2;

    std::ofstream fileResult("Y_e.txt");
    if (!fileResult.is_open()) {
        std::cout << "Error open file!";
        return ;
    }
    std::ofstream fileOriginal("Y_e_original.txt");
    if (!fileOriginal.is_open()) {
        std::cout << "Error open file!";
        return ;
    }


    std::vector<double> data = AilerCalc(x, k, a1, a2, b1, b2);
    std::copy(data.begin(), data.end(), std::ostream_iterator<double>(fileOriginal, "\n"));
    std::vector<double> noise(data.size());
    GenRandNumb gen;
    std::transform(data.begin(), data.end(), noise.begin(), [&gen](const double& y) { return y + gen.generate();});
    std::copy(noise.begin(), noise.end(), std::ostream_iterator<double>(fileResult, "\n"));

    fileOriginal.close();
    fileResult.close();
}

double calculate_CF(std::vector<double> y_e, std::vector<double> y_m) {
    double sum = std::transform_reduce(y_e.begin(), y_e.end(),
                                          y_m.begin(),
                                          0.0,
                                          std::plus<double>(),
                                          [](const double& y_ei, const double& y_mi) { return std::pow((y_ei - y_mi),2);});
    return sum / y_e.size();
}

struct Point {
    double x;
    double y;
    double value;
};
// Метод покоординатного спуска с адаптивным шагом
Point gauss_seidel_search(std::function<double(double, double)> f,
                         double x0, double y0, std::ofstream& fileIterationResults,
                         double initial_step, double min_step,
                         int max_iter,
                         double epsilon, bool verbose = false,
                         int verboseStep = 100) {
    Point current_point = {x0, y0, f(x0, y0)};
    Point previous_point = {0.0, 0.0, DBL_MAX};
    double step = initial_step;

    for (int iter = 0; iter < max_iter; ++iter) {
        Point best_point = current_point;
        bool improved = false;

        // Поиск по координате x
        Point trial_point = best_point;
        trial_point.x += step;
        trial_point.value = f(trial_point.x, trial_point.y);

        if (trial_point.value < best_point.value) {
            best_point = trial_point;
            improved = true;
        } else {
            trial_point.x = current_point.x - step;
            trial_point.value = f(trial_point.x, trial_point.y);

            if (trial_point.value < best_point.value) {
                best_point = trial_point;
                improved = true;
            }
        }

        // Поиск по координате y
        trial_point = best_point;
        trial_point.y += step;
        trial_point.value = f(trial_point.x, trial_point.y);

        if (trial_point.value < best_point.value) {
            best_point = trial_point;
            improved = true;
        } else {
            trial_point.y = current_point.y - step;
            trial_point.value = f(trial_point.x, trial_point.y);

            if (trial_point.value < best_point.value) {
                best_point = trial_point;
                improved = true;
            }
        }

        // Адаптация шага
        if (improved) {
            previous_point = current_point;
            current_point = best_point;
            // Увеличиваем шаг на 10% при успехе
            step *= 1.1;
        } else {
            // Уменьшаем шаг на 50% при неудаче
            step *= 0.5;
        }

        // Запись успешного шага в файл
        if (improved) {
            fileIterationResults << current_point.x << "\t" << current_point.y << "\t" << current_point.value << "\n";
        }

        if (verbose && iter % verboseStep == 0) {
            std::cout << "Итерация " << iter << ": (" << current_point.x << ", " << current_point.y
                 << "), значение: " << current_point.value << ", шаг: " << step << std::endl;
        }

        // Условия остановки
        if (std::abs(current_point.value - previous_point.value) <= epsilon) {
            if (verbose) {
                std::cout << "Достигнута требуемая точность на итерации " << iter << std::endl;
            }
            break;
        }

        if (step < min_step) {
            if (verbose) {
                std::cout << "Минимальный шаг достигнут на итерации " << iter << std::endl;
            }
            break;
        }
    }

    return current_point;
}

void searchFunc(std::function<double(double, double)> f,
                    double x0, double y0,
                    double initial_step = 1e-2, double min_step = 1e-7,
                    int max_iter = 500000,
                    double epsilon = 1e-8,
                    bool verbose = true,
                    int verboseStep = 10) {
    std::cout << "Тест:" << std::endl;
    std::cout << "Начальный шаг = " << initial_step << std::endl;
    std::cout << "Минимальный шаг = " << min_step << std::endl;
    std::cout << "Максимальное кол-во итераций = " << max_iter << std::endl;
    std::cout << "Эпсилон = " << epsilon << std::endl;
    std::cout << "Начальные координаты = " << "(" << x0 << "," << y0 << ")\n";

    std::ofstream fileIterationResults("iteration_results" + std::to_string(x0) + "_" + std::to_string(y0) + ".txt");
    if (!fileIterationResults.is_open()) {
        std::cout << "Error open file!";
        return;
    }

    Point res_ell = gauss_seidel_search(f, x0, y0, fileIterationResults, initial_step, min_step,
        max_iter, epsilon, verbose, verboseStep);

    fileIterationResults.close();

    std::cout << "\nРезультат:\nНайденный минимум: (" << res_ell.x << ", " << res_ell.y << ")\n"
         << "Значение функции: " << res_ell.value << std::endl;

    std::string fileName = "test_result_" + std::to_string(x0) + "_" + std::to_string(y0) + ".txt";
    std::ofstream fileTestResult(fileName);
    const int x = 5;
    const int k = 3;
    const int a1 = 5;
    const int a2 = 3;
    //const int b1 = 3;
    //const int b2 = 2;
    std::vector<double> res = AilerCalc(x, k, a1, a2, res_ell.x, res_ell.y);
    std::copy(res.begin(), res.end(), std::ostream_iterator<double>(fileTestResult, "\n"));
    fileTestResult.close();
}

int main()
{
    std::ifstream file_Y_noise("Y_e.txt");
    if (!file_Y_noise.is_open()) {
        std::cout << "Error open file!";
        return 1;
    }
    std::vector<double> y_e;
    std::copy(std::istream_iterator<double>(file_Y_noise), std::istream_iterator<double>(), std::back_insert_iterator(y_e));
    // Считать неизвестными b1 и b2
    // Метод оптимизации: покоординатный спуск с адаптивным шагом
    auto testSearchCF = [&y_e](double b1, double b2) -> double {
        const int x = 5;
        const int k = 3;
        const int a1 = 5;
        const int a2 = 3;
        //const int b1 = 3;
        //const int b2 = 2;
        std::vector<double> y_m = AilerCalc(x, k, a1, a2, b1, b2);
        return calculate_CF(y_e, y_m);
    };

    // Корректные значения 3, 2
    searchFunc(testSearchCF, 3.8, 2.9);
    searchFunc(testSearchCF, 4.1, 2.2);
    searchFunc(testSearchCF, 3.0, 2.1);
    searchFunc(testSearchCF, 2.4, 2.1);
    searchFunc(testSearchCF, 2.3, 1.5);

    return 0;
}
