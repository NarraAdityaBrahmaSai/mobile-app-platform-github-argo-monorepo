package com.mobileplatform.app

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val view = TextView(this).apply {
            text = "Mobile Platform"
            textSize = 24f
        }

        setContentView(view)
    }
}
