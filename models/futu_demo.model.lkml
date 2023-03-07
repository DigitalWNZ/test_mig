# Define the database connection to be used for this model.
connection: "futu_demo"

# include all the views
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: futu_demo_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: futu_demo_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Futu Demo"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: login_event {
  # sql_always_where: ${event_date} between date_sub(current_date(),interval {% parameter period_start %} day) and date_sub(current_date(),interval {% parameter period_end %} day) ;;
}

explore: position {}

explore: quotation {}

explore: pdt_suggest {}

explore: tt {}

explore: dt_partition_view {
  sql_always_where: dt is not null ;;
}


# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: events {
  sql_always_where:
   {% if events.g1_category._parameter_value == "'event_params'" %}
    (select COALESCE(safe_cast(params.value.int_value as string),safe_cast(params.value.float_value as string),safe_cast(params.value.double_value as string),params.value.string_value) as value from unnest(event_params) params where params.key={% parameter g1_category %}) = {% parameter ${g1_value}%}
   {% else %}
    (select COALESCE(safe_cast(up.value.int_value as string),safe_cast(up.value.float_value as string),safe_cast(up.value.double_value as string),up.value.string_value) as value from unnest(${user_properties}) up where up.key={% parameter g1_category %}) = {% parameter ${g1_value}%}
   {% endif %}
   and
   {% if events.g2_category._parameter_value == "'event_params'" %}
    {% parameter and_or %}  (select COALESCE(safe_cast(params.value.int_value as string),safe_cast(params.value.float_value as string),safe_cast(params.value.double_value as string),params.value.string_value) as value from unnest(event_params) params where params.key={% parameter g2_category %}) = {% parameter ${g2_value}%}
   {% else %}
     {% parameter and_or %} (select COALESCE(safe_cast(up.value.int_value as string),safe_cast(up.value.float_value as string),safe_cast(up.value.double_value as string),up.value.string_value) as value from unnest(${user_properties}) up where up.key={% parameter g2_category %}) = {% parameter ${g2_value}%}
   {% endif %}
    ;;
}


explore: key_value {}
