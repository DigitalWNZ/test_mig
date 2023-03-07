# The name of this view in Looker is "Dt Partition View"
view: dt_partition_view {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `agolis-allen-first.learnings.dt_partition_view`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dt ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Val" in Explore.

  dimension: val {
    type: number
    sql: ${TABLE}.val ;;
    suggest_persist_for: "1 seconds"
  }

  dimension: val_str {
    type: string
    sql: ${TABLE}.val_str ;;
    suggest_persist_for: "1 seconds"
  }


  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_val {
    type: sum
    sql: ${val} ;;
  }

  measure: average_val {
    type: average
    sql: ${val} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
