#include <iostream>
#include "PhoneBookManager.h"

// Главная программа
int main() {

    PhoneBookManager phoneBookManager;

    while (true) {
        std::cout << "\nMenu:\n"
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
        std::cin >> choice;
        std::cin.ignore(); // Очистка буфера после ввода числа

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
                std::cout << "Tap name: ";
                std::string name;
                getline(std::cin, name);
                std::cout << "Tap phone number: ";
                std::string phone;
                getline(std::cin, phone);

                phoneBookManager.insertRecord(PhoneBookManager::CRecord(name, phone), true);
                break;
            }
            case 5: {
                std::cout << "Tap name: ";
                std::string name;
                getline(std::cin, name);
                std::cout << "Tap phone number: ";
                std::string phone;
                getline(std::cin, phone);

                phoneBookManager.insertRecord(PhoneBookManager::CRecord(name, phone), false);
                break;
            }
            case 6: {
                std::cout << "Tap new name: ";
                std::string name;
                getline(std::cin, name);
                std::cout << "Tap new phone number: ";
                std::string phone;
                getline(std::cin, phone);

                phoneBookManager.replaceCurrentRecord(PhoneBookManager::CRecord(name, phone));
                break;
            }
            case 7: {
                std::cout << "Tap name: ";
                std::string name;
                getline(std::cin, name);
                std::cout << "Tap phone number: ";
                std::string phone;
                getline(std::cin, phone);

                phoneBookManager.insertAtEnd(PhoneBookManager::CRecord(name, phone));
                break;
            }
            case 8: {
                 std::cout << "Tap count of note to move (+/-): ";
                int n;
                 std::cin >> n;

                phoneBookManager.moveByN(n);
                break;
            }
            case 9: {
                 std::cout << "Exit program.\n";
                return 0;
            }
            default: {
                 std::cout << "Invalid input, try more.\n";
                break;
            }
        }
    }
}