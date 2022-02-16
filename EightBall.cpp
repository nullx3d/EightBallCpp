#include "stdafx.h"

using namespace std;

string getAnswer();

const string exitString = "x";
const int SIZEOF_ANSWERS = 8;
const int BUFSIZE = 255;
string magicEightBall = "The Magic 8 Ball says:";
string magicEightBallAnswers[SIZEOF_ANSWERS] = { "Yes", "No", "Maybe", "It's not certain", "The outlook is good",
                                                 "The outlook is poor", "Time will tell", "Most likely" };

int main(int argc, char* argv[])
{
    char keywords[BUFSIZE] = "";
    char buffer[BUFSIZ];
    
    srand(time(0));

    if (argc >= 2) {
        cout << "You have entered a question with " << argc-1 << " words:" << "\n";
        for (int i = 1; i < argc; ++i) {
            char* newArray = new char[std::strlen(keywords) + std::strlen(argv[i]) + 2];
            std::strcpy(newArray, keywords);
            std::strcat(newArray, argv[i]);
            std::strcat(newArray, (i == argc-1 ? "?" : " "));
            std::strcpy(keywords, newArray);
            //delete[] newArray;
        }
        keywords[0] = toupper(keywords[0]);

        cout << keywords << endl;
        cout << magicEightBall << endl;
        cout << getAnswer() << endl;
    } else {
        bool keepGoing = true;

        while (keepGoing)
        {
            string question;

            //prompt for and get the question
            cout << "What is your question?  (Enter 'x' to exit)" << endl;
            getline(cin, question);

            //this assumes that the user enters a lower case x
            if (question.compare(exitString) == 0)
                keepGoing = false;
            else
            {
                cout << magicEightBall << endl;
                cout << getAnswer() << endl;
            }
        }
    }

    return 0;
}


string getAnswer()
{
    int index = rand() % SIZEOF_ANSWERS;
    return magicEightBallAnswers[index];
}
