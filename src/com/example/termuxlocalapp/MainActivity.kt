package com.example.termuxlocalapp

import android.app.Activity
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.widget.LinearLayout
import android.widget.TextView

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val padding = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            24f,
            resources.displayMetrics
        ).toInt()

        val root = LinearLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(padding, padding, padding, padding)
        }

        val titleText = TextView(this).apply {
            text = "Termux Kotlin App"
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 24f)
            setTypeface(Typeface.DEFAULT_BOLD)
        }

        val statusText = TextView(this).apply {
            text = "Built in Termux on ${Build.MODEL} with Kotlin"
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = padding / 2
            }
        }

        root.addView(titleText)
        root.addView(statusText)
        setContentView(root)
    }
}
