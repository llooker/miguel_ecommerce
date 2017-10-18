connection: "thelook"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

datagroup: long_persistence {
  max_cache_age: "4 hours"
  #more info: https://docs.looker.com/data-modeling/learning-lookml/caching
}



explore: order_items {
  persist_with: long_persistence
  fields: [ALL_FIELDS*,-users.email] #example of hiding a single field, potentially to hide PII
  join: orders {
    relationship: many_to_one
    sql_on: ${orders.id}=${order_items.order_id} ;;
  }

  join: users {
    type: inner #using iner join because all orders should have a buyer associated to them
    view_label: "Buyers" #example of changing view label to buyers to make it clearer for the end-user
    relationship: many_to_one
    sql_on: ${users.id}=${orders.user_id};;
  }
  #created a user attribute called country, potentially to allow the end-user to only see purchases/buyers in their country
  sql_always_where: ${users.country}= {{ _user_attributes['country'] }} ;;

}

explore: users {
  join: user_data {
    type: inner
    relationship: one_to_one
    sql_on: ${users.id}=${user_data.id} ;;
  }
}

explore: inventory_items {
  always_filter: {
    filters: {
      field: products.brand #example required filter, potentially to get "brand managers" to search for their brands
    }
  }
  join: products {
    relationship: many_to_one
    sql_on: ${products.id}=${inventory_items.product_id} ;;
  }
}
