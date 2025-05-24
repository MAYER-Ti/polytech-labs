#include "genrandnumb.h"
#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <iterator>
#include <functional>
#include <random>

std::vector<double> AilerCalc(double x, double k, double a1, double a2, double mu, double t, int nIter = 1000, double h = 0.05) {
    std::vector<double> res(nIter);
    double z1 = 0;
    double z2 = 0;


    double dz1 = 0;
    double dz2 = 0;

    for (int i = 1; i < nIter; ++i) {
        dz1 = z1 + h * z2;
        dz2 = z2 + h * -(z1 + (2 * mu * t) * z2 - 10 / t * t);

        res[i] = k * z1 - a2 * k * z2 + a1 * k * z2 - a1 * a2 * k * dz2;

        z1 = dz1;
        z2 = dz2;
    }
    return res;
}


//!
//! \brief generateDefaultSequence
//! Процедура использовалась для записи Y_e в файл
//! Зашумленные данные
void generateDefaultSequence() {
    const double x = 10;
    const double k = 4;
    const double a1 = 2;
    const double a2 = 1;
    const double mu = 0.4;
    const double t = 4;

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


    std::vector<double> data = AilerCalc(x, k, a1, a2, mu, t);
    std::copy(data.begin(), data.end(), std::ostream_iterator<double>(fileOriginal, "\n"));
    fileOriginal.close();
    std::vector<double> noise(data.size());
    GenRandNumb gen;
    std::transform(data.begin(), data.end(), noise.begin(), [&gen](const double& y) { return y + gen.generate();});
    std::copy(noise.begin(), noise.end(), std::ostream_iterator<double>(fileResult, "\n"));
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
Point random_search_on_circle(std::function<double(double, double)> f,
                              double x_start,
                              double y_start,
                              std::ofstream& fileIterationResults,
                              double radius,
                              int max_iter,
                              double epsilon,
                              bool verbose = false,
                              std::ostream& log_stream = std::cout) {
    Point best_point = { x_start, y_start, f(x_start, y_start) };
    int no_improvement_count = 0;
    const int max_no_improvement = 1000; // Макс итераций без улучшения

    if (verbose) {
        log_stream << "Initial point: (" << best_point.x << ", " << best_point.y
                   << "), value: " << best_point.value << "\n";
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<double> angle_dist(0.0, 2 * M_PI);

    for (int i = 0; i < max_iter; ++i) {
        // Генерация точки на окружности с постоянным радиусом
        double angle = angle_dist(gen);
        Point current_point = {
            best_point.x + radius * cos(angle),
            best_point.y + radius * sin(angle),
            0.0
        };
        current_point.value = f(current_point.x, current_point.y);

        if (current_point.value < best_point.value) {
            double improvement = best_point.value - current_point.value;
            best_point = current_point;
            no_improvement_count = 0; // Сброс счетчика

            // Запись итераций поиска в файл
            fileIterationResults << best_point.x << "\t" << best_point.y << "\t" << best_point.value << "\n";

            if (verbose) {
                log_stream << "Iteration " << i << ": (" << best_point.x << ", " << best_point.y
                           << "), value: " << best_point.value << ", improvement: " << improvement << "\n";
            }

            // Условие остановки при достижении точности
            if (improvement < epsilon) {
                if (verbose) {
                    log_stream << "Converged at iteration " << i
                               << ": improvement " << improvement
                               << " below " << epsilon << "\n";
                }
                break;
            }
        }
        else {
            no_improvement_count++;
            // Условие остановки при отсутствии улучшений
            if (no_improvement_count >= max_no_improvement) {
                if (verbose) {
                    log_stream << "Terminated at iteration " << i
                               << ": no improvement for " << max_no_improvement
                               << " iterations\n";
                }
                break;
            }
        }
    }

    return best_point;
}

void searchFunc(std::function<double(double, double)> f,
                double x_start, double y_start,
                double initial_radius = 0.01,
                int max_iter = 500000,
                double epsilon = 1e-8,
                bool verbose = true,
                int verboseStep = 10) {
    std::cout << "Тест:" << std::endl;
    std::cout << "Начальный радиус = " << initial_radius << std::endl;
    std::cout << "Максимальное кол-во итераций = " << max_iter << std::endl;
    std::cout << "Эпсилон = " << epsilon << std::endl;
    std::cout << "Начальные координаты = " << "(" << x_start << "," << y_start << ")\n";

    std::ofstream fileIterationResults("iteration_results" + std::to_string(x_start) + "_" + std::to_string(y_start) + ".txt");
    if (!fileIterationResults.is_open()) {
        std::cout << "Error open file!";
        return;
    }

    Point res_ell = random_search_on_circle(f, x_start, y_start, fileIterationResults, initial_radius,
                                        max_iter, epsilon, verbose, std::cout);

    fileIterationResults.close();

    std::cout << "\nРезультат:\nНайденный минимум: (" << res_ell.x << ", " << res_ell.y << ")\n"
              << "Значение функции: " << res_ell.value << std::endl;

    std::string fileName = "test_result_" + std::to_string(x_start) + "_" + std::to_string(y_start) + ".txt";
    std::ofstream fileTestResult(fileName);
    const double x = 10;
    const double k = 4;
    const double a1 = 2;
    const double a2 = 1;
    //const double mu = 0.4;
    //const double t = 4;
    std::vector<double> res = AilerCalc(x, k, a1, a2, res_ell.x, res_ell.y);
    std::copy(res.begin(), res.end(), std::ostream_iterator<double>(fileTestResult, "\n"));
    fileTestResult.close();
}

int main()
{

    //generateDefaultSequence();

    std::ifstream file_Y_noise("Y_e.txt");
    if (!file_Y_noise.is_open()) {
        std::cout << "Error open file!";
        return 1;
    }
    std::vector<double> y_e;
    std::copy(std::istream_iterator<double>(file_Y_noise), std::istream_iterator<double>(), std::back_insert_iterator(y_e));
    // Считать неизвестными mu и t
    // Метод оптимизации: покоординатный спуск с адаптивным шагом
    auto testSearchCF = [&y_e](double mu, double t) -> double {
        const int x = 10;
        const int k = 4;
        const int a1 = 2;
        const int a2 = 1;
        //const int mu = 0.4;
        //const int t = 4;
        std::vector<double> y_m = AilerCalc(x, k, a1, a2, mu, t);
        return calculate_CF(y_e, y_m);
    };

    // Корректные значения 0.4, 4
    searchFunc(testSearchCF, 0.47, 4.2);
    searchFunc(testSearchCF, 0.41, 4.1);
    searchFunc(testSearchCF, 0.40, 4.0);
    searchFunc(testSearchCF, 0.39, 3.9);
    searchFunc(testSearchCF, 0.38, 3.8);
    searchFunc(testSearchCF, 0.20, 2.0);
    searchFunc(testSearchCF, 0.50, 5.0);


    return 0;
}
