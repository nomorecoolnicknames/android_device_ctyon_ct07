// SSL_ctrl for the stock mtk_agpsd (Android 6.0), part of libshim_ct07_icu.
//
// Pie's BoringSSL no longer exports SSL_ctrl. mtk_agpsd calls it once, as
// the old macro SSL_get0_certificate_types(ssl, &types) =
// SSL_ctrl(ssl, SSL_CTRL_GET_CLIENT_CERT_TYPES (103), 0, &types), and keeps
// at most 7 types (OpenSSL's old SSL3_CT_NUMBER), so the count is clamped
// to 7. Any other command is logged and fails.
#define LOG_TAG "libshim_ct07"

#include <log/log.h>
#include <openssl/ssl.h>

namespace {
constexpr int kCtrlGetClientCertTypes = 103;
constexpr size_t kMaxCertTypes = 7;
}  // namespace

extern "C" long SSL_ctrl(SSL* ssl, int cmd, long larg, void* parg) {
  if (cmd == kCtrlGetClientCertTypes) {
    const uint8_t* types = nullptr;
    size_t count = SSL_get0_certificate_types(ssl, &types);
    if (parg != nullptr) {
      *static_cast<const uint8_t**>(parg) = types;
    }
    return static_cast<long>(count < kMaxCertTypes ? count : kMaxCertTypes);
  }
  ALOGW("SSL_ctrl: unsupported cmd %d (larg %ld)", cmd, larg);
  return 0;
}
