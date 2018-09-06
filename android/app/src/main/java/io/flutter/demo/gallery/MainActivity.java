// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.demo.gallery;

import com.twohandslabs.knctd.bkjob.*;

import android.os.Bundle;

import com.evernote.android.job.JobManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

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
    }
}
