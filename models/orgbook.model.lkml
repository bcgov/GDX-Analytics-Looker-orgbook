connection: "redshift_pacific_time"

# include all the views
include: "/views/**/*.view"

datagroup: orgbook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

explore: orgbook {}

persist_with: orgbook_default_datagroup
