//
// Created by mayer on 20.02.2025.
//

#ifndef PRIORITYQUEUE_H
#define PRIORITYQUEUE_H

#include <deque>
#include <list>
#include <iostream>

class PriorityQueue {

public:
    enum ElementPriority {
        LOW,
        NORMAL,
        HIGH
    };

    struct QueueElement {
        std::string name;
    };

    // Конструктор, создает пустую очередь
    PriorityQueue();
    // Деструктор
    ~PriorityQueue();
    // Добавить в очередь элемент element с приоритетом priority
    void putElementToQueue(const QueueElement& element, ElementPriority priority);

    // Получить элемент из очереди
    // метод должен возвращать элемент с наибольшим приоритетом, который был
    // добавлен в очередь раньше других
    QueueElement getElementFromQueue();

    // Выполнить акселерацию
    void accelerate();

    const std::list<QueueElement>& getQueue(ElementPriority priority) const;

    private:
    std::deque<std::list<QueueElement>> _queue;

    friend std::ostream& operator<<(std::ostream& os, const QueueElement& queue);

    friend std::ostream& operator<<(std::ostream& os, const PriorityQueue& queue);

};



#endif //PRIORITYQUEUE_H
