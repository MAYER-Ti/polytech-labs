#include <vector>
#include <list>
#include <string>
#include <iterator>
#include <iostream>
#include <algorithm>

using namespace std;

// Class representing a record in a phonebok
class CRecord {
	string name, phone;
public:
	CRecord() :name("<unknown>"), phone("<unknown>") {} 
	CRecord(const CRecord &r) :name(r.getName()), phone(r.getPhone()) {}
	CRecord(const string &n,const string &p) :name(n), phone(p) {}
	~CRecord() {}

	CRecord& operator=(const CRecord &r) {
		setName(r.getName()); 
		setPhone(r.getPhone()); 
		return *this;
	}

	string getName() const {return name;}
	void setName(const string &n) {name=n;}
	string getPhone() const {return phone;}
	void setPhone(const string &n) {phone=n;}

	string toString() const {
		return "Name: "+getName()+"; Phone: "+getPhone()+"\n";
	}
};

typedef vector<CRecord> TDatabase;

TDatabase db;
TDatabase::iterator i;

// Command handlers:

string help() { // Show help
	return 
	"----------------STL iterators sample: phonebook-------------\n"
	"Command list:\n"
	"help - show this screen\n"
	"reset - reset iterator to first record\n"
	"curr - show current record\n"
	"next - move to next record\n"
	"prev - move to previous record\n"
	"nextn <n> - skip several records\n"
	"prevn <n> - skip several records backwards\n"
	"before <name> <phone> - insert a record before the current\n"
	"after <name> <phone> - insert a record after the current\n"
	"back <name> <phone> - insert a record at the end of the database\n"
	"change <name> <phone> - change the current record\n"
	"Ctrl-Z or F6 - quit"
	"------------------------------------------------------------\n";
}

template<class iter>
string modifyRecord(iter it) { // Modify a record pointed to by a specified iterator
	string name,phone;
	cin>>name>>phone;	// Input the new name and phone
	CRecord rec(name,phone);
	*it=rec;
	// Reset the iterator to the beginning of the database because
	// in the general case it will become deprecated (non-dereferenceable)
	i=db.begin();	
	
	return "Value: "+rec.toString();
}

string reset() { // Reset the iterator to the beginning of the database
	i=db.begin();
	return i->toString();
}
string curr() {	// Show current record
	return i->toString();
}
string next() {	// Move to next record and show it
	++i;
	return i->toString();
}
string prev() {	// Move to previous record and show it
	--i;
	return i->toString();
}
string nextn() { // Skip N records and show the Nth
	int pos;
	cin>>pos; // Read N
	advance(i,pos);
	return i->toString();
}
string prevn() { // Skip N records backwards
	int pos;
	cin>>pos;
	advance(i,pos);
	return i->toString();
}

// A command handler: called by transform() (see below)
string cmdHandler(string cmd) {
	try {
		if(cmd=="help") {
			return help();
		} else if(cmd=="reset") {
			return reset();
		} else if(cmd=="curr") {
			return curr();
		} else if(cmd=="next") {
			return next();
		} else if(cmd=="prev") {
			return prev();
		} else if(cmd=="nextn") {
			return nextn();
		} else if(cmd=="prevn") {
			return prevn();
		} else if(cmd=="before") {
			// Insert a record before the current: 
			// use an insert iterator into a position preceding the current.
			return modifyRecord(inserter<TDatabase,TDatabase::iterator>(db,--i));
		} else if(cmd=="after") {
			// Same: insert into the current position
			return modifyRecord(inserter<TDatabase,TDatabase::iterator>(db,i));
		} else if(cmd=="back") {
			// Insert to the end of the database (push back)
			return modifyRecord(back_inserter<TDatabase>(db));
		} else if(cmd=="change") {
			// Simply modify the current record
			return modifyRecord(i);
		} else {
			return "Invalid command! Type 'help' for a list of commands\n";
		}
	} catch(...) {
		return "Past-end iterator dereferenced!\n";
	}
}

int main() {
	string command;

	cout<<help();
	i=db.begin();
	
	// Read strings from cin until EOF, call cmdHandler(str) for each and
	// output the result of cmdHandler to cout.
	transform(istream_iterator<string>(cin), istream_iterator<string>(),
		ostream_iterator<string>(cout), cmdHandler);

	return 0;
}
