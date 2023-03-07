include: "/views/**/*.view"

view: key_value {
  derived_table: {
    sql:
      select
        distinct "event_params" as cat , params.key,
        COALESCE(safe_cast(params.value.int_value as string),
                 safe_cast(params.value.float_value as string),
                 safe_cast(params.value.double_value as string),
                 params.value.string_value) as value
      from `agolis-allen-first.bingoblast.events_*`,unnest(event_params) params
      union all
      select
      distinct "user_properties" as cat , up.key,
      COALESCE(safe_cast(up.value.int_value as string),
               safe_cast(up.value.float_value as string),
               safe_cast(up.value.double_value as string),
               up.value.string_value) as value
      from `agolis-allen-first.bingoblast.events_*`,unnest(user_properties) up
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: cat {
    type: string
    sql: ${TABLE}.cat ;;
  }
  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }

  set: detail {
    fields: [key, value]
  }
}
