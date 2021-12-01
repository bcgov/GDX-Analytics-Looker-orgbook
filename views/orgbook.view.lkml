include: "//snowplow_web_block/Includes/date_comparisons_common.view.lkml"

view: orgbook {

  derived_table: {
    sql: SELECT
      app_id, api_version, endpoint, response_time, total, parameters, internal_call,
      CASE WHEN parameters LIKE '%"category:entity_type"%' THEN 1 ELSE 0 END AS category_entity_type_count,
      CASE WHEN parameters LIKE '%"credential_type_id"%' THEN 1 ELSE 0 END AS credential_type_id_count,
      CASE WHEN parameters LIKE '%"format"%' THEN 1 ELSE 0 END AS format_count,
      CASE WHEN parameters LIKE '%"inactive"%' THEN 1 ELSE 0 END AS inactive_count,
      CASE WHEN parameters LIKE '%"issuer_id"%' THEN 1 ELSE 0 END AS issuer_id_count,
      CASE WHEN parameters LIKE '%"latest"%' THEN 1 ELSE 0 END AS latest_count,
      CASE WHEN parameters LIKE '%"name"%' THEN 1 ELSE 0 END AS name_count,
      CASE WHEN parameters LIKE '%"page"%' THEN 1 ELSE 0 END AS page_count,
      CASE WHEN parameters LIKE '%"page_size"%' THEN 1 ELSE 0 END AS page_size_count,
      CASE WHEN parameters LIKE '%"paging"%' THEN 1 ELSE 0 END AS paging_count,
      CASE WHEN parameters LIKE '%"q"%' THEN 1 ELSE 0 END AS q_count,
      CASE WHEN parameters LIKE '%"revoked"%' THEN 1 ELSE 0 END AS revoked_count,
      CASE WHEN parameters LIKE '%"topic_id"%' THEN 1 ELSE 0 END AS topic_id_count,
      CASE WHEN parameters = '[]' THEN 1 ELSE 0 END AS no_paramaters_count,

      CONVERT_TIMEZONE('UTC', 'America/Vancouver', oa.root_tstamp) AS timestamp
      FROM atomic.ca_bc_gov_orgbook_api_call_1 AS oa
      LEFT JOIN atomic.events AS ev ON oa.root_tstamp = ev.collector_tstamp AND oa.root_id = ev.event_id
      WHERE {% incrementcondition %} timestamp {% endincrementcondition %} -- this matches the table column used by increment_key
      ;;

    distribution_style: all
    datagroup_trigger: datagroup_15_45
    increment_key: "event_hour" # this, linked with increment_offset, says to consider "timestamp" and
    # to reprocess up to 3 hours of results
    increment_offset: 3
  }

  extends: [date_comparisons_common]
  dimension_group: filter_start {
    sql: ${TABLE}.timestamp ;;
  }
  parameter: summary_granularity { hidden: yes }
  dimension: summary_date { hidden: yes }
  dimension: in_summary_period { hidden: yes }


  dimension: app_id {}
  dimension: api_version {}
  dimension: endpoint {}
  dimension: response_time {}
  dimension: total {}
  dimension: parameters {}
  dimension: internal_call {
    type: yesno
  }
  dimension_group: event {
    type: time
    timeframes: [raw, time, minute, minute10, time_of_day, hour_of_day, hour, date, day_of_month, day_of_week, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }

  measure: response_time_average {
    type: average
    sql: ${response_time} ;;
  }
  measure: api_count {
    type: count
  }
  measure: category_entity_type_count {
    type: sum
    sql: ${TABLE}.category_entity_type_count ;;
  }
  measure: credential_type_id_count {
    type: sum
    sql: ${TABLE}.credential_type_id_count ;;
  }
  measure: format_count {
    type: sum
    sql: ${TABLE}.format_count ;;
  }
  measure: inactive_count {
    type: sum
    sql: ${TABLE}.inactive_count ;;
  }
  measure: issuer_id_count {
    type: sum
    sql: ${TABLE}.issuer_id_count ;;
  }
  measure: latest_count {
    type: sum
    sql: ${TABLE}.latest_count ;;
  }
  measure: name_count {
    type: sum
    sql: ${TABLE}.name_count ;;
  }
  measure: page_count {
    type: sum
    sql: ${TABLE}.page_count ;;
  }
  measure: page_size_count {
    type: sum
    sql: ${TABLE}.page_size_count ;;
  }
  measure: paging_count {
    type: sum
    sql: ${TABLE}.paging_count ;;
  }
  measure: q_count {
    type: sum
    sql: ${TABLE}.q_count ;;
  }
  measure: revoked_count {
    type: sum
    sql: ${TABLE}.revoked_count ;;
  }
  measure: topic_id_count {
    type: sum
    sql: ${TABLE}.topic_id_count ;;
  }
  measure: no_paramaters_count {
    type: sum
    sql: ${TABLE}.no_paramaters_count ;;
  }
}
