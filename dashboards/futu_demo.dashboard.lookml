- dashboard: futu_demo
  title: Futu_demo
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: 0sGrKarVMivdu9NlwJozgV
  elements:
  - title: Futu_demo
    name: Futu_demo
    model: futu_demo
    explore: login_event
    type: looker_column
    fields: [login_event.country, login_event.ctd_user_id]
    filters: {}
    sorts: [login_event.ctd_user_id desc 0]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    listen:
      Event Date: login_event.event_date
      Country: login_event.country
    row: 0
    col: 0
    width: 24
    height: 12
  filters:
  - name: Event Date
    title: Event Date
    type: field_filter
    default_value: 1 years
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: futu_demo
    explore: login_event
    listens_to_filters: []
    field: login_event.event_date
  - name: Country
    title: Country
    type: field_filter
    default_value: 'NULL'
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: futu_demo
    explore: login_event
    listens_to_filters: []
    field: login_event.country
