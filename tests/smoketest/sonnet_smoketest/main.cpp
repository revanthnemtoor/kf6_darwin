#include <QCoreApplication>
#include <Sonnet/Speller>
#include <sonnet_version.h>
#include <cstdio>
#include <cstring>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    Sonnet::Speller speller;
    std::printf("Sonnet Smoke Test\n");
    std::printf("  Version : %s\n", SONNET_VERSION_STRING);
    std::printf("  Clients : %lld\n", static_cast<long long>(speller.availableBackends().size()));

    if (std::strcmp(SONNET_VERSION_STRING, "6.31.0") != 0) {
        std::fprintf(stderr, "FAIL: Sonnet version mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::SonnetCore runtime test succeeded.\n");
    return 0;
}

