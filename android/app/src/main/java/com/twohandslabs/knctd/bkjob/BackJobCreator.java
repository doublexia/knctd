package com.twohandslabs.knctd.bkjob;

import android.content.Context;
import android.support.annotation.NonNull;

import com.evernote.android.job.Job;
import com.evernote.android.job.JobCreator;
import com.evernote.android.job.JobManager;

public class BackJobCreator implements JobCreator {

    @Override
    public Job create(String tag) {
        switch (tag) {
            case ScreenIdleJob.TAG:
                return new ScreenIdleJob();
            default:
                return null;
        }
    }
}