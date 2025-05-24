#ifndef PHONEBOOKMANAGER_H
#define PHONEBOOKMANAGER_H


#include <list>
#include <string>

// Класс телефонной книжки
class PhoneBookManager {
public:
    // Структура для хранения записи в телефонной книге
    struct CRecord {
        std::string name;
        std::string phone;

        CRecord(const std::string& name = "", const std::string& phone = "")
            : name(name), phone(phone) {}
    };
    // Определяем тип контейнера через using
    using PhoneBook = std::list<CRecord>;
    using iterator = PhoneBook::iterator;



public:
    // Конструктор: заполняет телефонную книгу начальными данными
    PhoneBookManager() ;

    // Просмотр текущей записи
    void viewCurrentRecord() const;

    // Переход к следующей записи
    void moveToNext();

    // Переход к предыдущей записи
    void moveToPrevious();

    // Вставка записи перед/после текущей
    void insertRecord(const CRecord& newRecord, bool before = true);

    // Замена текущей записи
    void replaceCurrentRecord(const CRecord& newRecord);

    // Вставка записи в конец базы данных
    void insertAtEnd(const CRecord& newRecord);

    // Переход вперед/назад через n записей
    void moveByN(int n);

    // Общая функция для модификации записи
    template <typename Iterator>
    void modifyRecord(Iterator position, const CRecord& newRecord) {
        *position = newRecord;
    }

private:
    PhoneBook phoneBook; // Контейнер для хранения записей
    iterator current;    // Итератор текущей записи
};



#endif //PHONEBOOKMANAGER_H
