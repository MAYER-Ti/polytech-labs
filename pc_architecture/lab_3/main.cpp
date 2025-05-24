#include <omp.h>
#include <iostream>
#include <unistd.h>

using namespace std;

void func()
{
    for (int i = 0; i < 500000; i++)
    {
        rand();
    }
}

int main()
{
    setlocale(LC_ALL, "Russian");

    //--------------------------------------
    // Task 2 (for, sections, OMP_GET_NUM_THREADS)
    //--------------------------------------

    // Задаем максимальнео количество потоков
    omp_set_num_threads(6);

#pragma omp parallel
    {
#pragma omp sections nowait
        {
#pragma omp section

            for (int i = 0; i < 10; i++)
            {
                cout << 1; func();
            }

#pragma omp section

            for (int i = 0; i < 10; i++)
            {
                cout << 2; func();
            }

#pragma omp section

            for (int i = 0; i < 10; i++)
            {
                cout << 3; func();
            }

#pragma omp section

            for (int i = 0; i < 10; i++)
            {
                cout << 4; func();
            }

#pragma omp section

            for (int i = 0; i < 10; i++)
            {
                cout << 5; func();
            }

#pragma omp section

            cout << "\nКоличество потоков: " << omp_get_num_threads() << endl;
        }

#pragma omp barrier

        cout << "\nbarrier";

    }

    cout << "\n\n-----------------------------------------------\n\n";

    //--------------------------------------
    // Task 2 (single, critical, master, atomic, ordered)
    //--------------------------------------

    // #pragma omp master, чтобы только главный (нулевой) поток вывел сообщение о начале работы.
    // #pragma omp ordered, чтобы потоки выполняли операции строго по порядку их номеров.

    int arr[8];

    omp_set_num_threads(8);

#pragma omp parallel
    {
        int thread_id = omp_get_thread_num();

// Только главный поток выполняет этот код
#pragma omp master
        {
            cout << "Начало заполнения массива.\n" << endl;
        }

#pragma omp for ordered

        for (int i = 0; i < 8; i++)
        {
            // Заполняем массив
            arr[i] = i;

#pragma omp ordered
            cout << "Поток " << thread_id << " записал arr[" << i << "] = " << arr[i] << endl;
        }
    }

    cout << "\nМассив заполнен.";

    cout << "\n\n-----------------------------------------------";

    //--------------------------------------
    // Task 3 (OMP_INIT_LOCK, OMP_SET_LOCK, OMP_UNSET_LOCK, OMP_TEST_LOCK)
    //--------------------------------------

    omp_set_num_threads(4);

    omp_lock_t lock;
    omp_init_lock(&lock);

    int n;

#pragma omp parallel private (n)
    {
        n = omp_get_thread_num();

        // Попытка потоков захватить замок
        while (!omp_test_lock(&lock))
        {
            // omp_test_lock(&lock) - проверяет, свободен ли замок.
            // Если замок свободен, поток захватывает его и выходит из while.
            // Если замок занят, поток застревает в while, печатает Waiting..., ждет 3 мс, затем снова проверяет.

            cout << "\n...Поток ждет: " << n;
            sleep(5);
        }

        cout << "\n\n-- Начало. Поток с замком: " << n << endl;

        sleep(15); // Work...

        cout << "\n\n-- Конец. Поток с замком: " << n << endl;

        omp_unset_lock(&lock);
    }

    omp_destroy_lock(&lock);
}
