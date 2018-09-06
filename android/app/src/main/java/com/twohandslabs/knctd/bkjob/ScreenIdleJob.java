package com.twohandslabs.knctd.bkjob;

import java.util.Set;
import java.util.concurrent.TimeUnit;

import android.util.Log;

import com.evernote.android.job.Job;
import com.evernote.android.job.JobConfig;
import com.evernote.android.job.JobManager;
import com.evernote.android.job.JobRequest;
import com.evernote.android.job.JobApi;
import com.evernote.android.job.util.support.PersistableBundleCompat;

public class ScreenIdleJob extends Job {
    public static final String TAG = "screen_idle_tag";

    @Override
    protected Result onRunJob(final Params params) {
        Log.e(TAG, "idled at "+System.currentTimeMillis());
        return Result.RESCHEDULE;
    }

    public static void scheduleJob() {
        Log.e(TAG, "schedule job");
        Set<JobRequest> jobRequests = JobManager.instance().getAllJobRequestsForTag(ScreenIdleJob.TAG);
        if (!jobRequests.isEmpty()) {
            return;
        }
        new JobRequest.Builder(ScreenIdleJob.TAG)
                .setPeriodic(TimeUnit.MINUTES.toMillis(15), TimeUnit.MINUTES.toMillis(7))
                .setUpdateCurrent(true) // calls cancelAllForTag(NoteSyncJob.TAG) for you
                .setRequiredNetworkType(JobRequest.NetworkType.ANY)
                .setRequiresDeviceIdle(true)
                .setRequirementsEnforced(true)
                .build()
                .schedule();

        Log.e(TAG, "job scheduled");
    }
}