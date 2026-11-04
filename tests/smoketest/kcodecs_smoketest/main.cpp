#include <QCoreApplication>
#include <KCodecs>
#include <kcodecs_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    const QByteArray b64 = KCodecs::base64Encode(QByteArrayLiteral("KF6CodecsDarwin"));
    const QByteArray dec = KCodecs::base64Decode(b64);

    std::printf("KCodecs Smoke Test\n");
    std::printf("  Version : %s\n", KCODECS_VERSION_STRING);
    std::printf("  Base64  : %s -> %s\n", b64.constData(), dec.constData());

    if (dec != QByteArrayLiteral("KF6CodecsDarwin")) {
        std::fprintf(stderr, "FAIL: KCodecs base64 round-trip mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::Codecs runtime test succeeded.\n");
    return 0;
}

