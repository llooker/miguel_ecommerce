view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
    drill_fields: [generation]
  }

  dimension: generation {
    type: string
    case: {
      when: {
        label: "G.I  Generation"
        sql: extract(year from current_date)-${age}>=1901 and  extract(year from current_date)-${age}<=1924;;
      }
      when: {
        label: "Silent Generation"
        sql: extract(year from current_date)-${age}>=1925 and  extract(year from current_date)-${age}<=1942;;
      }
      when: {
        label: "Baby Boomers"
        sql: extract(year from current_date)-${age}>=1943 and  extract(year from current_date)-${age}<=1960;;
      }
      when: {
        label: "Generation X"
        sql: extract(year from current_date)-${age}>=1961 and  extract(year from current_date)-${age}<=1981;;
      }
      when: {
        label: "Millennial"
        sql: extract(year from current_date)-${age}>=1982 and  extract(year from current_date)-${age}<=2001;;
      }
      when: {
        label: "Cyber Generation"
        sql: extract(year from current_date)-${age}>=2002 and  extract(year from current_date)-${age}<=2025;;
      }
      else: "Other"
    }
    drill_fields: [age]
    description: "Generation that a user is part of based on their age"
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
