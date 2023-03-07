# The name of this view in Looker is "Position"
view: position {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Futu_demo.position`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Quantity" in Explore.

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_quantity {
    type: sum
    sql: ${quantity} ;;
  }

  measure: average_quantity {
    type: average
    sql: ${quantity} ;;
  }

  dimension: stock_id {
    type: string
    sql: ${TABLE}.stock_id ;;
  }

  parameter: params_test {
    type: string
    allowed_value: {
      label: "stock"
      value: "stock"
    }
    allowed_value: {
      label: "user"
      value: "user"
    }
  }


  dimension: id {
    type: string
    sql:
      CASE
       WHEN {% parameter params_test %} = 'stock' THEN ${stock_id}
       WHEN {% parameter params_test %} = 'user' THEN ${user_id}
       ELSE NULL
      END ;;
  }

  parameter: suggest_test {
    type: string
    suggest_dimension: stock_id
  }

  parameter: suggest_explore_test {
    type: string
    suggest_explore:quotation
    suggest_dimension: quotation.stock_id
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
