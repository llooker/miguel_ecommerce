view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  #added yes no dimension to simplify querying for items that have/have not been returned
  dimension: was_returned {
    type: yesno
    sql: ${returned_date} is not null ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

  measure: female_sales {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.gender
      value: "f"
    }
    value_format_name: usd
    label: "Total Sales from Females"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  measure: percent_female_sales {
    type: number
    sql: ${female_sales}/${total_sales} ;;
    value_format_name: percent_2
    description: "Percent of sales from females out of total sales"
    label: "Percent of Sales from Females"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  measure: percent_male_sales {
    type: number
    sql: ${male_sales}/${total_sales} ;;
    value_format_name: percent_2
    description: "Percent of sales from males out of total sales"
    label: "Percent of Sales from Males"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  measure: male_sales {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.gender
      value: "m"
    }
    value_format_name: usd
    label: "Total Sales from Males"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  #added mean, max, min item value to allow analyzing buying habits of different segments of the buyer population
  measure: average_item_value {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Average value of an item"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  measure: max_item_value {
    type: max
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Maximum value of an item"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  measure: min_item_value {
    type: min
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Minimum value of an item"
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [id,order_id,orders.status,sale_price]
  }

  ##added this as an example of sum distinct when the tables are at different granularity levels
  measure: complete_count {
    type: sum_distinct
    sql_distinct_key: orders.id ;;
    sql: case when status="complete" then 1 else 0 end ;;
    drill_fields: [id,order_id,orders.status]
  }

  measure: incorrect_complete_count {
    type: sum
    sql: case when status="complete" then 1 else 0 end ;;
    drill_fields: [id,order_id,orders.status]
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: orders.id ;;
    sql: case when status="complete" then orders.id end ;;
    drill_fields: [id,order_id,orders.status]
  }

}
