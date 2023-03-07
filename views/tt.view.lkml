view: tt {
  derived_table: {
    datagroup_trigger: futu_demo_default_datagroup
    create_process: {
      sql_step:call ELM.get_sql('${SQL_TABLE_NAME}','x');;
      sql_step:select * from ELM.hello where test in (select test from ${SQL_TABLE_NAME});;

    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: test {
    type: number
    sql: ${TABLE}.test ;;
  }

  set: detail {
    fields: [test]
  }
}
