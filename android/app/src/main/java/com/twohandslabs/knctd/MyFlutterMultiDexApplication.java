package com.twohandslabs.knctd;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.CallSuper;
import android.support.multidex.MultiDex;
import android.support.multidex.MultiDexApplication;

import io.flutter.view.FlutterMain;

public class MyFlutterMultiDexApplication extends MultiDexApplication {
    private Activity mCurrentActivity = null;

    public MyFlutterMultiDexApplication() {
    }

    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }

    public Activity getCurrentActivity() {
        return this.mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }

    // MultiDex
    @Override
    protected void attachBaseContext(Context base)
    {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
