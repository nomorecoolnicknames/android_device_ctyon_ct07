/*
 * libmtk_agpsd_shim: symbols the stock Android 6.0 mtk_agpsd imports and
 * LineageOS 14.1 does not export:
 *
 *   ucnv_open_55 ucnv_close_55 ucnv_convertEx_55
 *   ucnv_setFromUCallBack_55 ucnv_setToUCallBack_55
 *   UCNV_FROM_U_CALLBACK_STOP_55 UCNV_TO_U_CALLBACK_STOP_55   (ICU 55)
 *   SSL_ctrl                                                  (BoringSSL)
 *
 * The ICU calls are forwarded to ICU 56 (same C API). SSL_ctrl is called
 * once, as the old SSL_get0_certificate_types() macro (command 103).
 * Injected as the first DT_NEEDED of mtk_agpsd by the linker
 * (LINKER_FORCED_SHIM_LIBS in BoardConfig.mk).
 */

#define LOG_TAG "mtk_agpsd_shim"

#include <log/log.h>

#include <unicode/ucnv.h>
#include <unicode/ucnv_err.h>
#include <unicode/utypes.h>

#include <openssl/ssl.h>

extern "C" {

/* ---- ICU 55 -> ICU 56 --------------------------------------------------- */

UConverter* ucnv_open_55(const char* converterName, UErrorCode* err) {
    return ucnv_open(converterName, err);
}

void ucnv_close_55(UConverter* converter) {
    ucnv_close(converter);
}

void ucnv_convertEx_55(UConverter* targetCnv, UConverter* sourceCnv,
                       char** target, const char* targetLimit,
                       const char** source, const char* sourceLimit,
                       UChar* pivotStart, UChar** pivotSource,
                       UChar** pivotTarget, const UChar* pivotLimit,
                       UBool reset, UBool flush, UErrorCode* pErrorCode) {
    ucnv_convertEx(targetCnv, sourceCnv, target, targetLimit, source,
                   sourceLimit, pivotStart, pivotSource, pivotTarget,
                   pivotLimit, reset, flush, pErrorCode);
}

void ucnv_setFromUCallBack_55(UConverter* converter,
                              UConverterFromUCallback newAction,
                              const void* newContext,
                              UConverterFromUCallback* oldAction,
                              const void** oldContext, UErrorCode* err) {
    ucnv_setFromUCallBack(converter, newAction, newContext, oldAction,
                          oldContext, err);
}

void ucnv_setToUCallBack_55(UConverter* converter,
                            UConverterToUCallback newAction,
                            const void* newContext,
                            UConverterToUCallback* oldAction,
                            const void** oldContext, UErrorCode* err) {
    ucnv_setToUCallBack(converter, newAction, newContext, oldAction,
                        oldContext, err);
}

/* The callbacks are passed by address into ucnv_set*UCallBack above, so ICU
 * 56 calls these wrappers, which hand over to its own STOP handlers. */
void UCNV_FROM_U_CALLBACK_STOP_55(const void* context,
                                  UConverterFromUnicodeArgs* fromUArgs,
                                  const UChar* codeUnits, int32_t length,
                                  UChar32 codePoint,
                                  UConverterCallbackReason reason,
                                  UErrorCode* err) {
    UCNV_FROM_U_CALLBACK_STOP(context, fromUArgs, codeUnits, length,
                              codePoint, reason, err);
}

void UCNV_TO_U_CALLBACK_STOP_55(const void* context,
                                UConverterToUnicodeArgs* toUArgs,
                                const char* codeUnits, int32_t length,
                                UConverterCallbackReason reason,
                                UErrorCode* err) {
    UCNV_TO_U_CALLBACK_STOP(context, toUArgs, codeUnits, length, reason, err);
}

/* ---- BoringSSL (M) SSL_ctrl --------------------------------------------- */

#define SHIM_SSL_CTRL_GET_CLIENT_CERT_TYPES 103  /* OpenSSL 1.0.2 ssl.h */

long SSL_ctrl(SSL* ssl, int cmd, long larg, void* parg) {
    switch (cmd) {
    case SHIM_SSL_CTRL_GET_CLIENT_CERT_TYPES: {
        const uint8_t* types = NULL;
        size_t n = SSL_get0_certificate_types(ssl, &types);
        if (parg != NULL) {
            *reinterpret_cast<const uint8_t**>(parg) = types;
        }
        return static_cast<long>(n);
    }
    default:
        /* Not reached by the stock binary (single call site, cmd 103). Keep
         * the OpenSSL contract for an unsupported ctrl: 0 = not supported. */
        ALOGW("SSL_ctrl(cmd=%d, larg=%ld) not implemented by the shim", cmd,
              larg);
        return 0;
    }
}

}  // extern "C"
