package com.kherwal.santhali_keyboard.santhali_keyboard

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.kherwal.santhali_keyboard/settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openInputSettings" -> {
                    openInputSettings()
                    result.success(true)
                }
                "showKeyboardPicker" -> {
                    showKeyboardPicker()
                    result.success(true)
                }
                "isKeyboardEnabled" -> {
                    result.success(isKeyboardEnabled())
                }
                "isKeyboardSelected" -> {
                    result.success(isKeyboardSelected())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun openInputSettings() {
        val intent = Intent(Settings.ACTION_INPUT_METHOD_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun showKeyboardPicker() {
        val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        im.showInputMethodPicker()
    }

    private fun isKeyboardEnabled(): Boolean {
        val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        val enabledMethods = im.enabledInputMethodList
        val packageName = packageName
        for (method in enabledMethods) {
            if (method.packageName == packageName) {
                return true
            }
        }
        return false
    }

    private fun isKeyboardSelected(): Boolean {
        val currentInputMethodId = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.DEFAULT_INPUT_METHOD
        )
        return currentInputMethodId != null && currentInputMethodId.contains(packageName)
    }
}
