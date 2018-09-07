package com.twohandslabs.knctd.bkjob;

import java.util.Set;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.text.SimpleDateFormat;


import android.util.Log;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

import com.evernote.android.job.Job;
import com.evernote.android.job.JobConfig;
import com.evernote.android.job.JobManager;
import com.evernote.android.job.JobRequest;
import com.evernote.android.job.JobApi;
import com.evernote.android.job.util.support.PersistableBundleCompat;

import static com.twohandslabs.knctd.bkjob.Utils.TAG;

public class ScreenIdleJob extends Job {

    @Override
    protected Result onRunJob(final Params params) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        Date date = new Date();
        Log.e(TAG, "idled at "+System.currentTimeMillis()+ " "+formatter.format(date));
        Utils.saveLastTimestamp(getContext(), date.getTime() /*System.currentTimeMillis()*/);
        return Result.RESCHEDULE;
    }

    public static void scheduleJob() {
        Log.e(TAG, "schedule job");
        Set<JobRequest> jobRequests = JobManager.instance().getAllJobRequestsForTag(TAG);
        if (!jobRequests.isEmpty()) {
            return;
        }
        Log.e(TAG, "job scheduled");
        new JobRequest.Builder(TAG)
                .setPeriodic(TimeUnit.MINUTES.toMillis(15), TimeUnit.MINUTES.toMillis(7))
                .setUpdateCurrent(true) // calls cancelAllForTag(NoteSyncJob.TAG) for you
                .setRequiredNetworkType(JobRequest.NetworkType.ANY)
                //.setRequiresDeviceIdle(true)
                //.setOverrideDeadline(0)
                //.setRequirementsEnforced(true)
                .build()
                .schedule();

    }
}