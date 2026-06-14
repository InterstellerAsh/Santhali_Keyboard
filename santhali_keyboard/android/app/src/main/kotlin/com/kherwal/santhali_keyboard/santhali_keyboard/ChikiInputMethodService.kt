package com.kherwal.santhali_keyboard.santhali_keyboard

import android.inputmethodservice.InputMethodService
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.FrameLayout
import android.widget.TextView
import android.view.Gravity

class ChikiInputMethodService : InputMethodService() {
    override fun onCreateInputView(): View {
        val frameLayout = FrameLayout(this)
        val textView = TextView(this)
        textView.text = "Chiki Keyboard Active"
        textView.gravity = Gravity.CENTER
        textView.textSize = 20f
        frameLayout.addView(textView)
        return frameLayout
    }
}
