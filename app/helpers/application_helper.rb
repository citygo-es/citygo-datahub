module ApplicationHelper
  def render_selectable_categories(categories, form, resource_type = :default_category, method_name = :default_category_ids)
    category_tags = ""

    case resource_type
    when :default_category
      base_element = "user[data_provider_attributes][data_resource_settings_attributes][#{form.options[:child_index]}][#{method_name}][]"
    when :role_resource
      base_element = "user[data_provider_attributes][#{method_name}][]"
    end

    categories.each do |category, subtree|
      tree_element = check_box_tag base_element, category.id, Array(form.object.send(method_name)).include?(category.id.to_s)
      tree_element += category.name
      tree_element += render_selectable_categories(subtree, form, resource_type, method_name)
      category_tags << content_tag("li", raw(tree_element))
    end
    content_tag("ul", raw(category_tags))
  end

  def render_categories(categories)
    category_tags = ""
    categories.each do |category, subtree|
      tree_element = []
      element_buttons = []

      tree_element << content_tag("span", "ID:#{category.id}", class: "badge badge-info")
      tree_element << category.name
      element_buttons << link_to("New Child", new_category_path(parent_id: category.id), class: "btn btn-xs btn-outline-success")
      element_buttons << link_to("Show", category_path(category), class: "btn btn-xs btn-outline-secondary")
      element_buttons << link_to("Edit", edit_category_path(category), class: "btn btn-xs btn-outline-secondary")
      element_buttons << link_to("Destroy", category, method: :delete, data: { confirm: "Are you sure? All children are destroyed as well!" }, class: "btn btn-xs btn-outline-danger")
      tree_element << content_tag("div", raw(element_buttons.join), class: "action-links")
      tree_element << render_categories(subtree)
      tree_element = tree_element.join(" ")
      category_tags << content_tag("li", raw(tree_element))
    end
    content_tag("ul", raw(category_tags))
  end
end
