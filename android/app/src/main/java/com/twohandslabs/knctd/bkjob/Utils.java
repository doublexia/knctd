package com.twohandslabs.knctd.bkjob;

import android.content.Context;
import android.content.SharedPreferences;

public class Utils {
    public static final String TAG = "screen_idle_tag";

    public static SharedPreferences getSharedPreferences(Context context) {
        return context.getSharedPreferences(TAG, Context.MODE_PRIVATE);
    }

    public static long getLastTimestamp(Context context) {
        SharedPreferences prefs = getSharedPreferences(context);

        return prefs.getLong(TAG, 0);
    }

    public static void saveLastTimestamp(Context context, long tstamp) {
        SharedPreferences prefs = getSharedPreferences(context);
        //SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getContext());
        SharedPreferences.Editor edit = prefs.edit();
        edit.putLong(TAG, tstamp);
        edit.commit();
    }
}
