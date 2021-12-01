connection: "redshift_pacific_time"

# include all the views
include: "/views/**/*.view"

datagroup: orgbook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

explore: orgbook {}

persist_with: orgbook_default_datagroup


datagroup: datagroup_15_45 {
  label: "15 and 45 Minute Datagroup"
  description: "Update every 30 minutes to drive incrementals PDT at 15 and 45 past the hour"
  sql_trigger: SELECT CASE WHEN DATE_PART('minute',timezone('America/Vancouver', now())) < 15 OR DATE_PART('minute',timezone('America/Vancouver', now())) >= 45
              THEN DATE_TRUNC('hour',timezone('America/Vancouver', now()))
            ELSE DATE_TRUNC('hour',timezone('America/Vancouver', now())) +  interval '30 minutes' END ;;
}


# include date comparisons
include: "//snowplow_web_block/Includes/date_comparisons_common.view.lkml"
