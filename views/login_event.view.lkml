# The name of this view in Looker is "Login Event"
view: login_event {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Futu_demo.login_event`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Country" in Explore.

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  parameter: period_start {
    type: number
  }

  parameter: period_end {
    type: number
  }

  parameter: pert {
    type: number
  }

  filter: dt_filter {
    type: date
  }

  parameter: dt_parms {
    type: date
  }

  parameter: dtt_parms {
    type: date_time
  }

  dimension: hello {
    type: number
    sql:
      {% parameter pert %} * 10;;
  }

  dimension: show_my_dimension_filter {
    sql: 0 ;;
    html:
      {{_filters['pert']}}*10 ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: event {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.event_time ;;
  }

  dimension: user_id {
    label: "the id of user"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  filter: eventdate {
    type: date
    suggest_dimension: event_date
    suggest_explore: login_event
  }

  measure: dummy {
    type: count
    html: the value is {{count._rendered_value}} from {{_filters['eventdate']}} ;;
  }

  measure:ctd_user_id{
    type: count_distinct
    sql: ${user_id} ;;
  }
}
