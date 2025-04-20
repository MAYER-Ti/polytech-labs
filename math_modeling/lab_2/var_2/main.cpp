#define _USE_MATH_DEFINES
#include <iostream>
#include <fstream>
#include <cmath>
#include <random>
#include <iomanip>
#include <functional>

using namespace std;

struct Point {
    double x, y, value;
};

Point random_search_on_circle(function<double(double, double)> f,
    double x_start, double y_start,
    double radius, // теперь просто radius вместо initial_radius
    int max_iter, double epsilon,
    bool verbose = false, ostream& log_stream = cout) {

    Point best_point = { x_start, y_start, f(x_start, y_start) };
    int no_improvement_count = 0;
    const int max_no_improvement = 1000; // Макс итераций без улучшения

    if (verbose) {
        log_stream << "Initial point: (" << best_point.x << ", " << best_point.y
            << "), value: " << best_point.value << endl;
    }

    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<double> angle_dist(0.0, 2 * M_PI);

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

            if (verbose) {
                log_stream << "Iteration " << i << ": (" << best_point.x << ", " << best_point.y
                    << "), value: " << best_point.value << ", improvement: " << improvement << endl;
            }

            // Условие остановки при достижении точности
            if (improvement < epsilon) {
                if (verbose) {
                    log_stream << "Converged at iteration " << i
                        << ": improvement " << improvement
                        << " below " << epsilon << endl;
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
                        << " iterations" << endl;
                }
                break;
            }
        }
    }

    return best_point;
}
// Test functions
double ellipsoid(double x, double y, double A = 2.0, double B = 3.0) {
    return pow(x / A, 2) + pow(y / B, 2);
}

double rosenbrock(double x, double y) {
    return pow(1 - x, 2) + 100 * pow(y - pow(x, 2), 2);
}

void run_test(const string& name, function<double(double, double)> func,
    double x_start, double y_start,
    double initial_radius,
    int test_num, ostream& log_stream) {

    log_stream << "\n=== Test " << test_num << " for function " << name << " ===" << endl;
    log_stream << "Starting point: (" << x_start << ", " << y_start << ")" << endl;
    log_stream << "Initial search radius: " << initial_radius << endl;

    const int max_iter = 50000;
    const double epsilon = 1e-6;

    Point result = random_search_on_circle(func, x_start, y_start,
        initial_radius, max_iter, epsilon,
        true, log_stream);

    log_stream << "\nTest " << test_num << " results:\n";
    log_stream << "Found minimum: (" << result.x << ", " << result.y << ")\n";
    log_stream << "Function value: " << result.value << endl;
    log_stream << "=================================" << endl;
}

int main() {
    ofstream out_file("optimization_results.txt");
    if (!out_file) {
        cerr << "Error opening results file!" << endl;
        return 1;
    }

    out_file << fixed << setprecision(6);
    cout << fixed << setprecision(6);

    // Ellipsoid tests
    auto ellipsoid_func1 = [](double x, double y) { return ellipsoid(x, y, 1.0, 1.0); };
    run_test("Ellipsoid (A=1, B=1)", ellipsoid_func1, 1.0, 1.0, 0.1, 1, cout);

    auto ellipsoid_func2 = [](double x, double y) { return ellipsoid(x, y, -2.0, 4.0); };
    run_test("Ellipsoid (A=-2, B=4)", ellipsoid_func2, -2.0, 4.0, 0.1, 2, cout);

    // Rosenbrock function tests
    run_test("Rosenbrock", rosenbrock, 2, 1, 0.1, 3, cout);
    run_test("Rosenbrock", rosenbrock, -2, 1, 0.1, 4, cout);

    out_file.close();
    cout << "Results saved to optimization_results.txt" << endl;

    return 0;
}