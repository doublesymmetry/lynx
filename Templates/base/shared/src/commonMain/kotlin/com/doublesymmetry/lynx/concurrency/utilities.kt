package com.doublesymmetry.lynx.concurrency

/**
 * Returns an immutable instance of an object.
 *
 * On Android, it simply echoes the input back because threads can have shared state.
 * On iOS, it calls .toImmutable method.
 *
 * ### Examples
 *
 * ```
 * val person = Person(name = "Bob").toImmutable(
 *
 * person.name = "Jerry" // error
 *
 * ```
 *
 */
expect fun <T> T.toImmutable(): T

/**
 * Returns if the current thread is main thread.
 *
 * ### Examples
 *
 * ```
 *
 * JobDispatcher.dispatchOnMainThread(Unit) {
 *     assertTrue(isMainThread())
 * }
 *
 * JobDispatcher.dispatchOnBackgroundThread(Unit) {
 *     assertFalse(isMainThread())
 * }
 *
 * ```
 */
expect fun isMainThread(): Boolean