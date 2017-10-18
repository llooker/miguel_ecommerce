view: user_data {
  sql_table_name: demo_db.user_data ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: max_num_orders {
    type: number
    sql: ${TABLE}.max_num_orders ;;
  }

  dimension: total_num_orders {
    type: number
    sql: ${TABLE}.total_num_orders ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id]
  }

  #new engagement dimension using tiers, groups users into cohorts based on purchase frequency
  dimension: engagement {
    type: tier
    tiers: [1,3,5]
    style: integer
    sql: ${total_num_orders} ;;
    description: "Measure of user engagement with marketplace based on lifetime number of orders"
  }
}
