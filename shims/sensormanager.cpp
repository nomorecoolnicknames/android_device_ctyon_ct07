// SensorManager for the stock camera sensor listener
// (libcam.utils.sensorlistener.so, Android 6.0).
//
// The library has M's inline SensorManager::getInstanceForPackage() built
// in: it allocates the object with the M size, operator new(40), and calls
// the constructor from libsensor. Pie's SensorManager is 64 bytes, so the
// constructor writes the direct channel members over the start of the next
// heap block. In the camera provider that block is often a string of the
// camera parameters, and the next getParameters or setParameters crashes.
//
// The 40-byte object only keeps a pointer to a SensorManager of the right
// size, and the two methods the library calls are forwarded to it. The
// constructor is entered with SensorManager::sLock held, so the real object
// is constructed here and not through getInstanceForPackage().
#include <dlfcn.h>

#include <log/log.h>
#include <sensor/Sensor.h>
#include <sensor/SensorEventQueue.h>
#include <sensor/SensorManager.h>
#include <utils/String16.h>
#include <utils/String8.h>

using android::Sensor;
using android::SensorEventQueue;
using android::SensorManager;
using android::String16;
using android::String8;
using android::sp;

// The object as the library allocated it (40 bytes).
struct LegacySensorManager {
  SensorManager* real;
};

namespace {

// The names below are exported by this library too, so the libsensor
// definitions are looked up explicitly.
void* libsensor_symbol(const char* name) {
  static void* lib = dlopen("libsensor.so", RTLD_NOW);
  void* sym = lib ? dlsym(lib, name) : nullptr;
  LOG_ALWAYS_FATAL_IF(sym == nullptr, "libsensor.so: no %s", name);
  return sym;
}

}  // namespace

extern "C" void _ZN7android13SensorManagerC1ERKNS_8String16E(
    LegacySensorManager* self, const String16& opPackageName) {
  using Ctor = void (*)(void*, const String16&);
  static Ctor ctor = reinterpret_cast<Ctor>(
      libsensor_symbol("_ZN7android13SensorManagerC1ERKNS_8String16E"));
  void* real = ::operator new(sizeof(SensorManager));
  ctor(real, opPackageName);
  self->real = static_cast<SensorManager*>(real);
}

extern "C" Sensor const* _ZN7android13SensorManager16getDefaultSensorEi(
    LegacySensorManager* self, int type) {
  using Fn = Sensor const* (*)(SensorManager*, int);
  static Fn fn = reinterpret_cast<Fn>(
      libsensor_symbol("_ZN7android13SensorManager16getDefaultSensorEi"));
  return fn(self->real, type);
}

sp<SensorEventQueue> legacy_createEventQueue(LegacySensorManager* self,
                                             String8 packageName, int mode)
    __asm__("_ZN7android13SensorManager16createEventQueueENS_7String8Ei");

sp<SensorEventQueue> legacy_createEventQueue(LegacySensorManager* self,
                                             String8 packageName, int mode) {
  using Fn = sp<SensorEventQueue> (*)(SensorManager*, String8, int);
  static Fn fn = reinterpret_cast<Fn>(
      libsensor_symbol("_ZN7android13SensorManager16createEventQueueENS_7String8Ei"));
  return fn(self->real, packageName, mode);
}
