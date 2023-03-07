include: "/views/**/*.view"

view: pop_native_frame {
  extends: [users]

  parameter: choose_breakdown {
    label: "Choose Grouping (Rows)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Month"
    allowed_value: {label: "Month Name" value:"Month"}
    allowed_value: {label: "Day of Year" value: "DOY"}
    allowed_value: {label: "Day of Month" value: "DOM"}
    allowed_value: {label: "Day of Week" value: "DOW"}
    allowed_value: {value: "Date"}
  }

  parameter: choose_comparison {
    label: "Choose Comparison (Pivot)"
    view_label: "_PoP"
    type: unquoted
    default_value: "Year"
    allowed_value: {value: "Year" }
    allowed_value: {value: "Month"}
    allowed_value: {value: "Week"}
  }

  dimension: pop_row  {
    view_label: "_PoP"
    label_from_parameter: choose_breakdown
    type: string
    order_by_field: sort_by1 # Important
    sql:
      {% if choose_breakdown._parameter_value == 'Month' %} ${first_month_name}
      {% elsif choose_breakdown._parameter_value == 'DOY' %} ${first_day_of_year}
      {% elsif choose_breakdown._parameter_value == 'DOM' %} ${first_day_of_month}
      {% elsif choose_breakdown._parameter_value == 'DOW' %} ${first_day_of_week}
      {% elsif choose_breakdown._parameter_value == 'Date' %} ${first_date}
      {% else %}NULL{% endif %} ;;
  }

  dimension: pop_pivot {
    view_label: "_PoP"
    label_from_parameter: choose_comparison
    type: string
    order_by_field: sort_by2 # Important
    sql:
    {% if choose_comparison._parameter_value == 'Year' %} ${first_year}
    {% elsif choose_comparison._parameter_value == 'Month' %} ${first_month_name}
    {% elsif choose_comparison._parameter_value == 'Week' %} ${first_week}
    {% else %}NULL{% endif %} ;;
  }


  # These dimensions are just to make sure the dimensions sort correctly
  dimension: sort_by1 {
    hidden: yes
    type: number
    sql:
    {% if choose_breakdown._parameter_value == 'Month' %} ${first_month_num}
    {% elsif choose_breakdown._parameter_value == 'DOY' %} ${first_day_of_year}
    {% elsif choose_breakdown._parameter_value == 'DOM' %} ${first_day_of_month}
    {% elsif choose_breakdown._parameter_value == 'DOW' %} ${first_day_of_week_index}
    {% elsif choose_breakdown._parameter_value == 'Date' %} ${first_date}
    {% else %}NULL{% endif %} ;;
  }

  dimension: sort_by2 {
    hidden: yes
    type: string
    sql:
    {% if choose_comparison._parameter_value == 'Year' %} ${first_year}
    {% elsif choose_comparison._parameter_value == 'Month' %} ${first_month_num}
    {% elsif choose_comparison._parameter_value == 'Week' %} ${first_week}
    {% else %}NULL{% endif %} ;;
  }
}
