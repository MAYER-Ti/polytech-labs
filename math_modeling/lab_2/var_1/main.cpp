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
    setlocale(LC_CTYPE, "rus");
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
    testSearchFunc(ellipsoid_func, 2.1, 0.5, initial_step, min_step, max_iter, epsilon, true, 5);
    std::cout << "Тест 2\n";
    global_A = 5.0;
    global_B = 0.5;
    std::cout << "При A = " << global_A << ", " << "B = " << global_B << std::endl;
    testSearchFunc(ellipsoid_func, 2.1, 0.5, initial_step, min_step, max_iter, epsilon, true, 5);

    // Тест 2: Розенброк
    std::cout << "\n=== Функция Розенброка ===" << std::endl;
    std::cout << "Тест 1\n";
    testSearchFunc(rosenbrock, -2.0, 1.0, initial_step, min_step, max_iter, epsilon, true, 100);
    std::cout << "Тест 2\n";
    testSearchFunc(rosenbrock, 2.0, 1.0, initial_step, min_step, max_iter, epsilon, true, 100);


    return 0;
}
