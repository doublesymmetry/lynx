package com.doublesymmetry.lynx.concurrency

import platform.Foundation.NSThread
import kotlin.native.concurrent.freeze

actual fun isMainThread(): Boolean {
    return NSThread.isMainThread
}

actual fun <T> T.toImmutable(): T {
    return this.freeze()
}