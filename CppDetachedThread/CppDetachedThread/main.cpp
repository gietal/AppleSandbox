//
//  main.cpp
//  CppDetachedThread
//
//  Created by gietal on 7/12/21.
//

#include <iostream>
#include <string>
#include <thread>
#include <chrono>

class TestClass {
public:
    int foo;
};

std::shared_ptr<TestClass> gObject = std::make_shared<TestClass>();

void thread_fn() {
//  std::this_thread::sleep_for (std::chrono::seconds(1));
    while (1) {
        std::cout << gObject->foo << std::endl;
    }
}

int main()
{
    gObject->foo = 123;
    std::thread t1(thread_fn);
    t1.detach();

    std::this_thread::sleep_for(std::chrono::milliseconds(1));
    return 0;
}
