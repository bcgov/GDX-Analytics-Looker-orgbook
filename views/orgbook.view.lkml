view: orgbook {

  sql_table_name: atomic.ca_bc_gov_orgbook_api_call_1 ;;


  dimension: api_version {}
  dimension: endpoint {}
  dimension: response_time {}
  dimension: total {}
  dimension: parameters {}
  dimension: internal_call {}
  dimension_group: root_tstamp {
    type: time
    timeframes: [date, day_of_month, day_of_week, week, month, month_name, quarter, fiscal_quarter, year]
  }
}
