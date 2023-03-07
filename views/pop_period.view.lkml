include: "/views/**/*.view"
view: pop_period {
  extends: [users]

  filter: current_date_range {
    type: date
    view_label: "_PoP"
    label: "1. Current Date Range"
    description: "Select the current date range you are interested in. Make sure any other filter on Event Date covers this period, or is removed."
    sql: ${first_date} IS NOT NULL;;
    convert_tz: no
  }

  parameter: compare_to {
    view_label: "_PoP"
    description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
    label: "2. Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Week"
      value: "Week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "Month"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "Quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "Year"
    }
    default_value: "Period"
    # view_label: "_PoP" view_label having been declared twice in the article
  }

  dimension: days_in_period {
    # hidden:  yes
    view_label: "_PoP"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATE_DIFF(DATE({% date_end current_date_range %}),DATE({% date_start current_date_range %}), DAY) ;;
  }

  dimension: period_2_start {

    # hidden:  yes
    view_label: "_PoP"
    description: "Calculates the start of the previous period"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL ${days_in_period} DAY)
        {% else %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
    convert_tz: no
  }

  dimension: period_2_end {
    # hidden:  yes
    view_label: "_PoP"
    description: "Calculates the end of the previous period"
    type: date
    sql:
        {% if compare_to._parameter_value == "Period" %}
        DATE_SUB(DATE({% date_start current_date_range %}), INTERVAL 1 DAY)
        {% else %}
        DATE_SUB(DATE_SUB(DATE({% date_end current_date_range %}), INTERVAL 1 DAY), INTERVAL 1 {% parameter compare_to %})
        {% endif %};;
    convert_tz: no
  }

  dimension: day_in_period {
    hidden: yes
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} timestamp(${first_raw}) {% endcondition %}
        THEN DATE_DIFF( ${first_date},DATE({% date_start current_date_range %}), DAY) + 1
        WHEN ${first_raw} between ${period_2_start} and ${period_2_end}
        THEN DATE_DIFF(${first_date},${period_2_start}, DAY) + 1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }

  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${first_raw} {% endcondition %}
            THEN 1
            WHEN ${first_date}between ${period_2_start} and ${period_2_end}
            THEN 2
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }
  dimension_group: date_in_period {
      sql: DATE_ADD(DATE({% date_start current_date_range %}), INTERVAL (${day_in_period} - 1) DAY)  ;;
      view_label: "_PoP"
      timeframes: [
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week_of_year,
      month,
      month_name,
      month_num,
      year]
    convert_tz: no
  }


  dimension: period {
      view_label: "_PoP"
      label: "Period"
      description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
      type: string
      order_by_field: order_for_period
      sql:
      {% if current_date_range._is_filtered %}
      CASE
      WHEN {% condition current_date_range %} timestamp(${first_raw}) {% endcondition %}
      THEN 'This {% parameter compare_to %}'
      WHEN ${first_date} between ${period_2_start} and ${period_2_end}
      THEN 'Last {% parameter compare_to %}'
      END
      {% else %}
      NULL
      {% endif %}
      ;;
      }

      dimension: period_filtered_measures {
      hidden: yes
      description: "We just use this for the filtered measures"
      type: string
      sql:
      {% if current_date_range._is_filtered %}
      CASE
      WHEN {% condition current_date_range %} timestamp(${first_raw}) {% endcondition %} THEN 'this'
      WHEN ${first_date} between ${period_2_start} and ${period_2_end} THEN 'last' END
      {% else %} NULL {% endif %} ;;
      }


  measure: current_period_count{
    view_label: "_PoP"
    type: count
    filters: [period_filtered_measures: "this"]

  }

  measure: previous_period_count {
    view_label: "_PoP"
    type: count
    filters: [period_filtered_measures: "last"]
  }

  measure: sales_pop_change {
    view_label: "_PoP"
    label: "% change"
    type: number
    sql: CASE WHEN ${current_period_count} = 0
            THEN NULL
            ELSE (1.0 * ${current_period_count} / NULLIF(${previous_period_count} ,0)) - 1 END ;;
    value_format_name: percent_2
  }

  measure: count {
    type: count
  }
}
