connection: "redshift_pacific_time"

# include all the views
include: "/views/**/*.view"

datagroup: orgbook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

explore: orgbook {}

persist_with: orgbook_default_datagroup

## To avoid the "overnight-defrag" window, when the hour is 3, 4, or 5, return a fixed time
##    of the last run before 3:15am so these are "paused" during that window
##    The common code looks like:
##        SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
##                 THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
##    This is because the triggers return either the hour or the half hour depending on when they are in their window.

datagroup: datagroup_15_45 {
  label: "15 and 45 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 15 and 45 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('hour',timezone('America/Vancouver', now())) BETWEEN 3 AND 5
                  THEN DATE(timezone('America/Vancouver', now())) + interval '150 minutes'
            WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 15 OR DATE_PART('minute',timezone('America/Vancouver', now())) >= 45
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes' END ;;
}


# include date comparisons
include: "//snowplow_web_block/Includes/date_comparisons_common.view.lkml"
