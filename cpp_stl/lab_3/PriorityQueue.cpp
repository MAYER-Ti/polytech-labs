//
// Created by mayer on 20.02.2025.
//

#include "PriorityQueue.h"

PriorityQueue::PriorityQueue() {
    for (int i = LOW; i <= HIGH; i++) {
        _queue.emplace_back(); // Добавить список для каждого приоритета
    }
}

PriorityQueue::~PriorityQueue() {

}

void PriorityQueue::putElementToQueue(const QueueElement &element, ElementPriority priority) {
    _queue[priority].push_back(element);
}

PriorityQueue::QueueElement PriorityQueue::getElementFromQueue() {
    if (!_queue[HIGH].empty()) {
        QueueElement element = _queue[HIGH].front();
        _queue[HIGH].pop_front();
        return element;
    }

    else if (!_queue[NORMAL].empty()) {
        QueueElement element = _queue[NORMAL].front();
        _queue[NORMAL].pop_front();
        return element;
    }
    else if (!_queue[LOW].empty()) {
        QueueElement element = _queue[LOW].front();
        _queue[LOW].pop_front();
        return element;
    }
    else {
        return {};
    }
}

void PriorityQueue::accelerate() {
    _queue[HIGH].splice(_queue[HIGH].end(), _queue[LOW]);
}

const std::list<PriorityQueue::QueueElement> & PriorityQueue::getQueue(ElementPriority priority) const {
    return _queue[priority];
}

std::ostream & operator<<(std::ostream &os, const PriorityQueue::QueueElement& element) {
    return os << element.name;
}

std::ostream & operator<<(std::ostream &os, const PriorityQueue& queue) {
    os << "LOW: ";
    for (const auto& el : queue.getQueue(PriorityQueue::LOW)) {
        os << el << " ";
    }
    os << std::endl;

    os << "NORMAL: ";
    for (const auto& el : queue.getQueue(PriorityQueue::NORMAL)) {
        os << el << " ";
    }
    os << std::endl;

    os << "HIGH: ";
    for (const auto& el : queue.getQueue(PriorityQueue::HIGH)) {
        os << el << " ";
    }
    os << std::endl;

    return os;
}
