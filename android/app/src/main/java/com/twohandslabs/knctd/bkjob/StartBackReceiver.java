package com.twohandslabs.knctd.bkjob;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.evernote.android.job.JobManager;

public class StartBackReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        JobManager.create(context).addJobCreator(new BackJobCreator());

        ScreenIdleJob.scheduleJob();
    }
}