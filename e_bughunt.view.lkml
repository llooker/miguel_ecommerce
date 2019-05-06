view: e_bughunt {
  derived_table: {
    datagroup_trigger: bughunt_erin
    sql: -- use existing user_facts in tmp.LR$S260DPNTAVKY8W5EIBA7_user_facts
      SELECT
        user_facts.id  AS `user_facts.id`,
        user_data.total_num_orders  AS `user_data.total_num_orders`
      FROM demo_db.users  AS users
      INNER JOIN demo_db.user_data  AS user_data ON users.id=user_data.id
      INNER JOIN tmp.LR$S260DPNTAVKY8W5EIBA7_user_facts AS user_facts ON users.id=user_facts.id

      GROUP BY 1,2
      ORDER BY user_facts.id
      LIMIT 5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_facts_id {
    type: number
    sql: ${TABLE}.`user_facts.id` ;;
  }

  dimension: user_data_total_num_orders {
    type: number
    sql: ${TABLE}.`user_data.total_num_orders` ;;
  }

  set: detail {
    fields: [user_facts_id, user_data_total_num_orders]
  }
}
