/*
 * libshim_ct07: symbols the stock Android 6.0 MediaTek blobs import and
 * Android 9 no longer exports.
 */
#include <pthread.h>
#include <sys/types.h>

/*
 * __pthread_gettid: private bionic helper removed in O. Imported by
 * libvcodecdrv.so (loaded with libGLES_mali.so), libMtkOmxVdecEx.so and
 * libmtkjpeg.so.
 */
pid_t __pthread_gettid(pthread_t t)
{
    return pthread_gettid_np(t);
}

/*
 * MediaTek voice-unlock statics on android::AudioSystem, imported by the
 * stock audio.primary.mt6737t.so and never part of AOSP. The HAL calls them
 * only for voice unlock; no-op returns.
 */
#include <stddef.h>
#include <stdint.h>

#define VU_STUB(ret, name, mangled, params, retval) \
    ret name params __asm__(mangled);               \
    ret name params { return retval; }

#define U __attribute__((unused))
VU_STUB(int, ct07_vu_ReadRefFromRing,
        "_ZN7android11AudioSystem15ReadRefFromRingEPvjS1_",
        (void *a U, uint32_t b U, void *c U), 0)
VU_STUB(int, ct07_vu_SetVoiceUnlockSRC,
        "_ZN7android11AudioSystem17SetVoiceUnlockSRCEjj",
        (uint32_t a U, uint32_t b U), 0)
VU_STUB(int, ct07_vu_stopVoiceUnlockDL,
        "_ZN7android11AudioSystem17stopVoiceUnlockDLEv", (void), 0)
VU_STUB(int, ct07_vu_startVoiceUnlockDL,
        "_ZN7android11AudioSystem18startVoiceUnlockDLEv", (void), 0)
VU_STUB(int, ct07_vu_GetVoiceUnlockULTime,
        "_ZN7android11AudioSystem20GetVoiceUnlockULTimeEPv", (void *a U), 0)
VU_STUB(int, ct07_vu_GetVoiceUnlockDLLatency,
        "_ZN7android11AudioSystem23GetVoiceUnlockDLLatencyEv", (void), 0)
VU_STUB(void *, ct07_vu_getVoiceUnlockDLInstance,
        "_ZN7android11AudioSystem24getVoiceUnlockDLInstanceEv", (void), NULL)
VU_STUB(int, ct07_vu_freeVoiceUnlockDLInstance,
        "_ZN7android11AudioSystem25freeVoiceUnlockDLInstanceEv", (void), 0)
