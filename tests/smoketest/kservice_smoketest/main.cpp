#include <QCoreApplication>
#include <KSycoca>
#include <iostream>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    const int ver = KSycoca::version();
    if (ver <= 0) return 1;
    std::cout << "KF6::Service smoke test passed: KSycoca version=" << ver << std::endl;
    return 0;
}

