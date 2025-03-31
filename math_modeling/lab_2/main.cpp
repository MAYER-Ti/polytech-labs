#include <float.h>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <functional>
struct Point {
    double x;
    double y;
    double value;
};

Point gauss_seidel_search(std::function<double(double, double)> f,
                          double x0, double y0,
                          double initial_step,
                          double min_step,
                          int max_iter,
                          double epsilon = 1e-6,
                          bool verbose = false) {

    Point best_point = { x0, y0, f(x0, y0) };
    Point previous_point = {0.0, 0.0, -DBL_MAX};
    double step = initial_step;

    for (int iter = 0; iter < max_iter; ++iter) {
        bool improved = false;

        // Поиск по координате x
        Point trial_point = best_point;
        trial_point.x += step;
        trial_point.value = f(trial_point.x, trial_point.y);

        if (trial_point.value < best_point.value) {
            previous_point = best_point;
            best_point = trial_point;
            improved = true;
        } else {
            trial_point.x = best_point.x - step;
            trial_point.value = f(trial_point.x, trial_point.y);

            if (trial_point.value < best_point.value) {
                previous_point = best_point;
                best_point = trial_point;
                improved = true;
            }
        }

        // Поиск по координате y
        trial_point = best_point;
        trial_point.y += step;
        trial_point.value = f(trial_point.x, trial_point.y);

        if (trial_point.value < best_point.value) {
            previous_point = best_point;
            best_point = trial_point;
            improved = true;
        } else {
            trial_point.y = best_point.y - step;
            trial_point.value = f(trial_point.x, trial_point.y);

            if (trial_point.value < best_point.value) {
                previous_point = best_point;
                best_point = trial_point;
                improved = true;
            }
        }

        // Адаптация шага
        if (improved) {
            step *= 1.1; // Увеличиваем шаг на 10%
        } else {
            step *= 0.5; // Уменьшаем шаг на 50%
        }

        if (verbose && iter % 100 == 0) {
            std::cout << "Итерация " << iter << ": (" << best_point.x << ", " << best_point.y
                 << "), значение: " << best_point.value << ", шаг: " << step << std::endl;
        }

        // Условия остановки
        if (step < min_step) {
            if (verbose) {
                std::cout << "Минимальный шаг достигнут на итерации " << iter << std::endl;
            }
            break;
        }

        if (std::abs(best_point.value - previous_point.value) < epsilon) {
            if (verbose) {
                std::cout << "Достигнута требуемая точность на итерации " << iter << std::endl;
            }
            break;
        }
    }

    return best_point;
}

// Тестовые функции
double ellipsoid(double x, double y, double A = 1.0, double B = 1.0) {
    return pow(x / A, 2) + pow(y / B, 2);
}

double rosenbrock(double x, double y) {
    return pow(1 - x, 2) + 100 * pow(y - pow(x, 2), 2);
}

int main() {
    setlocale(LC_ALL, "rus");
    // Параметры поиска
    const int max_iter = 500000;
    const double epsilon = 1e-8;
    const double initial_step = 0.01;
    const double min_step = 1e-7;

    std::cout << std::fixed << std::setprecision(6);

    // Тест 1: Эллипсоид
    std::cout << "=== Функция эллипсоида ===" << std::endl;
    auto ellipsoid_func = [](double x, double y) { return ellipsoid(x, y, 1.0, 1.0); };
    Point res_ell = gauss_seidel_search(ellipsoid_func, 1, 1, initial_step, min_step,
        max_iter, epsilon, true);

    std::cout << "\nРезультат:\nНайденный минимум: (" << res_ell.x << ", " << res_ell.y << ")\n"
         << "Значение функции: " << res_ell.value << std::endl;

    // Тест 2: Розенброк
    std::cout << "\n=== Функция Розенброка ===" << std::endl;
    Point res_ros = gauss_seidel_search(rosenbrock, 1, 1, initial_step, min_step,
        max_iter, epsilon, true);

    std::cout << "\nРезультат:\nНайденный минимум: (" << res_ros.x << ", " << res_ros.y << ")\n"
         << "Значение функции: " << res_ros.value << std::endl;

    return 0;
}
