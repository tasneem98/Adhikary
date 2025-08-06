package com.tmi_group.adhikary

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

/**
 * Implementation of App Widget functionality.
 * First: Import HomeWidgetPlugin
 */
import  es.antonborri.home_widget.HomeWidgetPlugin // ---> Import the home widget plugin

// End of My "Tasneem" Editing

/**
 * Implementation of App Widget functionality.
 */
class ZekrWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            /**
             * Second: Update the widget
             */
            val widgetData = HomeWidgetPlugin.getData(context) // --> Get the data from Flutter App
            val views = RemoteViews(
                context.packageName,
                R.layout.zekr_widget
            ).apply { // --> Apply the layout

                val textFromFlutterApp = widgetData.getString("the_zekr", null) // --> Get the data
                setTextViewText(
                    R.id.zekr_text_id,
                    textFromFlutterApp ?: "No data from Flutter App"
                ) // --> Set the data

            }

            /**
             * Third: remove this line commented
             */
            //  updateAppWidget(context, appWidgetManager, appWidgetId) // --> Remove this line

            /***
             * Fourth: Update the widget
             */
            appWidgetManager.updateAppWidget(appWidgetId, views) // --> Update the widget

// End of My "Tasneem" Editing

        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetText = context.getString(R.string.appwidget_text) // Edited
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.zekr_widget)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}