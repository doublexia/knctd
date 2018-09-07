// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.demo.gallery;

import com.twohandslabs.knctd.bkjob.*;

import android.os.Bundle;

import com.evernote.android.job.JobManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "knctd.twohandslabs.com/timestamp";

    private FlutterGalleryInstrumentation instrumentation;

    /** Instrumentation for testing. */
    public FlutterGalleryInstrumentation getInstrumentation() {
        return instrumentation;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        JobManager.create(this).addJobCreator(new BackJobCreator());
        ScreenIdleJob.scheduleJob();

        GeneratedPluginRegistrant.registerWith(this);
        instrumentation = new FlutterGalleryInstrumentation(this.getFlutterView());

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if (call.method.equals("loadTimestamp")) {
                            result.success(Utils.getLastTimestamp(MainActivity.this));
                        }
                    }
        });
    }
}
