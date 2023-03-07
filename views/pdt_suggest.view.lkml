view: pdt_suggest {
  derived_table: {
    sql:
    create_process:{
      sql_step:
        call ELM.get_sql({% parameter hello %});
      sql_step:
        select * from ELM.hello where 1 in (select * from ELM.hello);
    };;

  }

    # select stock_id,user_id, quantity from Futu_demo.position where  {% condition stock_filter %} stock_id {% endcondition %}
    # ;;
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  parameter: hello {
    type: string
  }

  dimension: stock_id {
    type: string
    sql: ${TABLE}.stock_id ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  filter: stock_list {
    type: string
    suggest_explore: position
    suggest_dimension: position.stock_id
    sql:user_id in (select user_id from Futu_demo.position  where {% condition stock_list %} ${stock_id} {% endcondition %});;
  }


  filter: stock_filter {
    type: string
    suggest_explore: position
    suggest_dimension: position.stock_id
    # sql: {% condition stock_filter %} ${stock_id} {% endcondition %} ;;
  }

  parameter:  pt{

  }

  set: detail {
    fields: [stock_id, quantity]
  }
}
