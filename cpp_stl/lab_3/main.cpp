#include "PriorityQueue.h"

int main() {

    PriorityQueue queue;
    // Заполнение LOW приоритета
    for (char i = '1'; i <= '9'; i++) {
        queue.putElementToQueue({{i}}, PriorityQueue::LOW);
    }
    // Заполнение NORMAL приоритета
    for (char i = 'a'; i <= 'f'; i++) {
        queue.putElementToQueue({{i}}, PriorityQueue::NORMAL);
    }
    // Заполнение NORMAL приоритета
    for (char i = 'A'; i <= 'F'; i++) {
        queue.putElementToQueue({{i}}, PriorityQueue::HIGH);
    }

    std::cout << "default priority queue:\n" << queue;

    queue.accelerate();

    std::cout << "after accelerate:\n" << queue;

    queue.getElementFromQueue();
    std::cout << "pop high element:\n" << queue;

    while (!queue.getQueue(PriorityQueue::HIGH).empty()) {
        queue.getElementFromQueue();
    }
    queue.getElementFromQueue();
    std::cout << "pop element when high priority is empty:\n" << queue;

    return 0;
}
