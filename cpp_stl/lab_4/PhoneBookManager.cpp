#include "PhoneBookManager.h"
#include <iostream>

PhoneBookManager::PhoneBookManager() {
    phoneBook = {
        {"Ivan Ivanov", "+79001234567"},
        {"Petr Petrov", "+79012345678"},
        {"Sidor Sidorov", "+79023456789"}
    };
    current = phoneBook.begin(); // Устанавливаем итератор на первую запись
}

// Просмотр текущей записи
void PhoneBookManager::viewCurrentRecord() const {
    if (current != phoneBook.end()) {
        std::cout << "Current note: " << current->name << " - " << current->phone << std::endl;
    } else {
        std::cout << "Book is empty!" << std::endl;
    }
}

// Переход к следующей записи
void PhoneBookManager::moveToNext() {
    if (current != phoneBook.end()) {
        ++current;
        if (current == phoneBook.end()) {
            std::cout << "End of book.\n";
            --current; // Возвращаемся на последнюю запись
        }
    }
}

// Переход к предыдущей записи
void PhoneBookManager::moveToPrevious() {
    if (current != phoneBook.begin()) {
        --current;
    } else {
        std::cout << "Begin of book.\n";
    }
}

// Вставка записи перед/после текущей
void PhoneBookManager::insertRecord(const CRecord& newRecord, bool before) {
    if (before) {
        current = phoneBook.insert(current, newRecord);
    } else {
        current = phoneBook.insert(++current, newRecord);
        --current; // Возвращаем итератор на текущую запись
    }
}

// Замена текущей записи
void PhoneBookManager::replaceCurrentRecord(const CRecord& newRecord) {
    if (current != phoneBook.end()) {
        *current = newRecord;
    } else {
        std::cout << "Error: invalid input.\n";
    }
}

// Вставка записи в конец базы данных
void PhoneBookManager::insertAtEnd(const CRecord& newRecord) {
    phoneBook.push_back(newRecord);
    current = prev(phoneBook.end()); // Перемещаем итератор на последнюю запись
}

// Переход вперед/назад через n записей
void PhoneBookManager::moveByN(int n) {
    if (n > 0) {
        advance(current, std::min(n, static_cast<int>(distance(current, phoneBook.end())) - 1));
    } else if (n < 0) {
        advance(current, std::max(n, -static_cast<int>(distance(phoneBook.begin(), current))));
    }
}