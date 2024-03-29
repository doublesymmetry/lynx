package com.doublesymmetry.lynx.concurrency

import android.os.Looper

actual fun isMainThread(): Boolean {
    return Looper.myLooper() == Looper.getMainLooper()
}


actual fun <T> T.toImmutable(): T {
    return this;
}