#include <iostream>
#include <list>
#include <string>
#include <iterator> // Для std::next и std::prev

using namespace std;

// Структура для хранения записи в телефонной книге
struct CRecord {
    string name;
    string phone;

    CRecord(const string& name = "", const string& phone = "")
        : name(name), phone(phone) {}
};

// Класс телефонной книжки
class PhoneBookManager {
public:
    // Определяем тип контейнера через using
    using PhoneBook = list<CRecord>;
    using iterator = PhoneBook::iterator;

private:
    PhoneBook phoneBook; // Контейнер для хранения записей
    iterator current;    // Итератор текущей записи

public:
    // Конструктор: заполняет телефонную книгу начальными данными
    PhoneBookManager() {
        phoneBook = {
            {"Ivan Ivanov", "+79001234567"},
            {"Petr Petrov", "+79012345678"},
            {"Sidor Sidorov", "+79023456789"}
        };
        current = phoneBook.begin(); // Устанавливаем итератор на первую запись
    }

    // Просмотр текущей записи
    void viewCurrentRecord() const {
        if (current != phoneBook.end()) {
            cout << "Current note: " << current->name << " - " << current->phone << endl;
        } else {
            cout << "Book is empty!" << endl;
        }
    }

    // Переход к следующей записи
    void moveToNext() {
        if (current != phoneBook.end()) {
            ++current;
            if (current == phoneBook.end()) {
                cout << "End of book.\n";
                --current; // Возвращаемся на последнюю запись
            }
        }
    }

    // Переход к предыдущей записи
    void moveToPrevious() {
        if (current != phoneBook.begin()) {
            --current;
        } else {
            cout << "Begin of book.\n";
        }
    }

    // Вставка записи перед/после текущей
    void insertRecord(const CRecord& newRecord, bool before = true) {
        if (before) {
            current = phoneBook.insert(current, newRecord);
        } else {
            current = phoneBook.insert(++current, newRecord);
            --current; // Возвращаем итератор на текущую запись
        }
    }

    // Замена текущей записи
    void replaceCurrentRecord(const CRecord& newRecord) {
        if (current != phoneBook.end()) {
            *current = newRecord;
        } else {
            cout << "Error: invalid input.\n";
        }
    }

    // Вставка записи в конец базы данных
    void insertAtEnd(const CRecord& newRecord) {
        phoneBook.push_back(newRecord);
        current = prev(phoneBook.end()); // Перемещаем итератор на последнюю запись
    }

    // Переход вперед/назад через n записей
    void moveByN(int n) {
        if (n > 0) {
            advance(current, min(n, static_cast<int>(distance(current, phoneBook.end())) - 1));
        } else if (n < 0) {
            advance(current, max(n, -static_cast<int>(distance(phoneBook.begin(), current))));
        }
    }

    // Общая функция для модификации записи
    template <typename Iterator>
    void modifyRecord(Iterator position, const CRecord& newRecord) {
        *position = newRecord;
    }
};

// Главная программа
int main() {

    PhoneBookManager phoneBookManager;

    while (true) {
        cout << "\nMenu:\n"
             << "1. Look current note\n"
             << "2. Move to next note\n"
             << "3. Move to previous note\n"
             << "4. Insert before current note\n"
             << "5. Insert after current note\n"
             << "6. Change current note\n"
             << "7. Append to end\n"
             << "8. Move next/prev by n\n"
             << "9. Exit\n"
             << "Choose: ";

        int choice;
        cin >> choice;
        cin.ignore(); // Очистка буфера после ввода числа

        switch (choice) {
            case 1: {
                phoneBookManager.viewCurrentRecord();
                break;
            }
            case 2: {
                phoneBookManager.moveToNext();
                break;
            }
            case 3: {
                phoneBookManager.moveToPrevious();
                break;
            }
            case 4: {
                cout << "Tap name: ";
                string name;
                getline(cin, name);
                cout << "Tap phone number: ";
                string phone;
                getline(cin, phone);

                phoneBookManager.insertRecord(CRecord(name, phone), true);
                break;
            }
            case 5: {
                cout << "Tap name: ";
                string name;
                getline(cin, name);
                cout << "Tap phone number: ";
                string phone;
                getline(cin, phone);

                phoneBookManager.insertRecord(CRecord(name, phone), false);
                break;
            }
            case 6: {
                cout << "Tap new name: ";
                string name;
                getline(cin, name);
                cout << "Tap new phone number: ";
                string phone;
                getline(cin, phone);

                phoneBookManager.replaceCurrentRecord(CRecord(name, phone));
                break;
            }
            case 7: {
                cout << "Tap name: ";
                string name;
                getline(cin, name);
                cout << "Tap phone number: ";
                string phone;
                getline(cin, phone);

                phoneBookManager.insertAtEnd(CRecord(name, phone));
                break;
            }
            case 8: {
                cout << "Tap count of note to move (+/-): ";
                int n;
                cin >> n;

                phoneBookManager.moveByN(n);
                break;
            }
            case 9: {
                cout << "Exit program.\n";
                return 0;
            }
            default: {
                cout << "Invalid input, try more.\n";
                break;
            }
        }
    }

    return 0;
}