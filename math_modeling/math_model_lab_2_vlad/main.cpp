#include <iostream>
#include <cmath>
#include <random>
#include <iomanip>
#include <functional>
#include <float.h>

using namespace std;

static double global_A = 1.0;
static double global_B = 1.0;

struct Point {
    double x, y, value;
};

// Улучшенный метод случайного поиска с адаптацией области
Point improved_random_search(function<double(double, double)> f,
                             double x0,    double y0,
                             double x_min, double x_max,
                             double y_min, double y_max,
                             int max_iter, double epsilon,
                             bool verbose = false,
                             int verboseStep = 100) {
    random_device rd;
    mt19937 gen(rd());

    // Начальная случайная точка
    // uniform_real_distribution<double> x_dist(x_min, x_max);
    // uniform_real_distribution<double> y_dist(y_min, y_max);


    Point best_point;
    Point previous_point {0.0, 0.0, DBL_MAX};
    // best_point.x = x_dist(gen);
    // best_point.y = y_dist(gen);
    best_point.x = x0;
    best_point.y = y0;
    best_point.value = f(best_point.x, best_point.y);

    // Параметры адаптации
    //double shrink_factor = 0.9; // Коэффициент сужения области
    double initial_range_x = x_max - x_min;
    double initial_range_y = y_max - y_min;

    int countTry = 0; // Кол-во неудачных попыток

    for (int i = 0; i < max_iter; ++i) {
        // Сужение области поиска вокруг лучшей точки
        // double current_range_x = initial_range_x * pow(shrink_factor, i / 100.0);
        // double current_range_y = initial_range_y * pow(shrink_factor, i / 100.0);

        // uniform_real_distribution<double> new_x_dist(max(x_min, best_point.x - current_range_x / 2),
        //                                              min(x_max, best_point.x + current_range_x / 2));
        // uniform_real_distribution<double> new_y_dist(max(y_min, best_point.y - current_range_y / 2),
        //                                              min(y_max, best_point.y + current_range_y / 2));

        uniform_real_distribution<double> new_x_dist(max(x_min, best_point.x - initial_range_x / 2),
                                                     min(x_max, best_point.x + initial_range_x / 2));
        uniform_real_distribution<double> new_y_dist(max(y_min, best_point.y - initial_range_y / 2),
                                                     min(y_max, best_point.y + initial_range_y / 2));

        Point current_point;
        current_point.x = new_x_dist(gen);
        current_point.y = new_y_dist(gen);
        current_point.value = f(current_point.x, current_point.y);

        if (current_point.value < best_point.value) {
            previous_point = best_point;
            best_point = current_point;
            countTry = 0;
        }
        else {
            countTry++;
        }

        if (verbose && i % verboseStep == 0) {
            cout << "Итерация " << i << ": (" << best_point.x << ", " << best_point.y
                 << "), значение: " << best_point.value << endl;
        }

        // Условия остановки
        // if ((current_range_x/2.0) <= epsilon) {
        //     if (verbose) {
        //         std::cout << "Достигнута требуемая точность на итерации " << i << std::endl;
        //     }
        //     break;
        // }


        // if (countTry > 10000) {
        //     if (verbose) {
        //         std::cout << "Достигнуто количество попыток " << "> 10000" << " на итерации " << i << std::endl;
        //     }
        //     break;
        // }
        if (std::abs(best_point.value - previous_point.value) <= epsilon) {
            if (verbose) {
                std::cout << "Достигнута требуемая точность на итерации " << i << std::endl;
            }
            break;
        }
    }

    return best_point;
}

// Тестовые функции
double ellipsoid(double x, double y) {
    return pow(x / global_A, 2) + pow(y / global_B, 2);
}

double rosenbrock(double x, double y) {
    return pow(1 - x, 2) + 100 * pow(y - pow(x, 2), 2);
}


void testSearchFunc(std::function<double(double, double)> f,
                    double x0, double y0,
                    double x_min, double x_max,
                    double y_min, double y_max,
                    int max_iter,
                    double epsilon,
                    bool verbose = true,
                    int verboseStep = 100) {

    std::cout << "Границы x = " << "[" << x_min << ", " << x_max << "]" << std::endl;
    std::cout << "Границы y = " << "[" << y_min << ", " << y_max << "]" << std::endl;
    std::cout << "Максимальное кол-во итераций = " << max_iter << std::endl;
    std::cout << "Эпсилон = " << epsilon << std::endl;
    std::cout << "Начальные координаты = " << "(" << x0 << "," << y0 << ")\n";
    Point res_ell = improved_random_search(ellipsoid, x0, y0, x_min, x_max, y_min, y_max, max_iter, epsilon, verbose, verboseStep);

    std::cout << "\nРезультат:\nНайденный минимум: (" << res_ell.x << ", " << res_ell.y << ")\n"
              << "Значение функции: " << res_ell.value << std::endl;
}

int main() {
    setlocale(LC_ALL, "rus");
    // Параметры поиска
    const int max_iter = 5000000;
    const double epsilon = 1e-6;
    const double x_min = -0.5;
    const double x_max = 0.5;
    const double y_min = -0.5;
    const double y_max = 0.5;


    std::cout << std::fixed << std::setprecision(6);

    // Тест 1: Эллипсоид
    std::cout << "=== Функция эллипсоида ===" << std::endl;
    std::cout << "Тест 1\n";
    std::cout << "При A = " << global_A << ", " << "B = " << global_B << std::endl;

    testSearchFunc(ellipsoid, 2.1, 0.5, x_min, x_max, y_min, y_max, max_iter, epsilon, true, 10000);
    std::cout << "Тест 2\n";
    global_A = 5.0;
    global_B = 0.5;
    std::cout << "При A = " << global_A << ", " << "B = " << global_B << std::endl;
    testSearchFunc(ellipsoid, 2.1, 0.5, x_min, x_max, y_min, y_max, max_iter, epsilon, true, 10000);

    // Тест 2: Розенброк
    std::cout << "\n=== Функция Розенброка ===" << std::endl;
    std::cout << "Тест 1\n";
    testSearchFunc(rosenbrock, -2.0, 1.0, x_min, x_max, y_min, y_max, max_iter, epsilon, true, 10000);
    std::cout << "Тест 2\n";
    testSearchFunc(rosenbrock, 2.0, 1.0, x_min, x_max, y_min, y_max, max_iter, epsilon, true, 10000);


    return 0;
}



/*
 *

 *
 *
 *
#include <float.h>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <functional>

static double global_A = 1.0;
static double global_B = 1.0;

struct Point {
    double x;
    double y;
    double value;
};

// Метод покоординатного спуска с адаптивным шагом
Point gauss_seidel_search(std::function<double(double, double)> f,
                         double x0, double y0,
                         double initial_step, double min_step,
                         int max_iter,
                         double epsilon,
                         bool verbose = false,
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

// Тестовые функции
double ellipsoid(double x, double y, double A = 1.0, double B = 1.0) {
    return pow(x / A, 2) + pow(y / B, 2);
}

double rosenbrock(double x, double y) {
    return pow(1 - x, 2) + 100 * pow(y - pow(x, 2), 2);
}

void testSearchFunc(std::function<double(double, double)> f,
                    double x0, double y0,
                    double initial_step, double min_step,
                    int max_iter,
                    double epsilon,
                    bool verbose = true,
                    int verboseStep = 100) {

    std::cout << "Начальный шаг = " << initial_step << std::endl;
    std::cout << "Минимальный шаг = " << min_step << std::endl;
    std::cout << "Максимальное кол-во итераций = " << max_iter << std::endl;
    std::cout << "Эпсилон = " << epsilon << std::endl;
    std::cout << "Начальные координаты = " << "(" << x0 << "," << y0 << ")\n";
    Point res_ell = gauss_seidel_search(f, x0, y0, initial_step, min_step,
        max_iter, epsilon, verbose, verboseStep);

    std::cout << "\nРезультат:\nНайденный минимум: (" << res_ell.x << ", " << res_ell.y << ")\n"
         << "Значение функции: " << res_ell.value << std::endl;
}

int main() {
    setlocale(LC_ALL, "rus");
    // Параметры поиска
    const int max_iter = 500000;
    const double epsilon = 1e-8;
    const double initial_step = 1e-2;
    const double min_step = 1e-7;

    std::cout << std::fixed << std::setprecision(8);

    // Тест 1: Эллипсоид
    std::cout << "=== Функция эллипсоида ===" << std::endl;
    std::cout << "Тест 1\n";
    std::cout << "При A = " << global_A << ", " << "B = " << global_B << std::endl;
    auto ellipsoid_func = [](double x, double y) { return ellipsoid(x, y, global_A, global_B); };
    testSearchFunc(ellipsoid_func, 2.1, 0.5, initial_step, min_step, max_iter, epsilon, true, 2);
    std::cout << "Тест 2\n";
    global_A = 5.0;
    global_B = 0.5;
    std::cout << "При A = " << global_A << ", " << "B = " << global_B << std::endl;
    testSearchFunc(ellipsoid_func, 2.1, 0.5, initial_step, min_step, max_iter, epsilon, true, 2);

    // Тест 2: Розенброк
    std::cout << "\n=== Функция Розенброка ===" << std::endl;
    std::cout << "Тест 1\n";
    testSearchFunc(rosenbrock, -2.0, 1.0, initial_step, min_step, max_iter, epsilon, true, 50);
    std::cout << "Тест 2\n";
    testSearchFunc(rosenbrock, 2.0, 1.0, initial_step, min_step, max_iter, epsilon, true, 50);


    return 0;
}

*/









