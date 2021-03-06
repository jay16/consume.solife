#encoding: utf-8
module UsersHelper
  def from_group_members(user)
    user.groups.map do |g| 
      if g.accept 
        info = content_tag(:span, "同意共享", {class: "label label-info", style: "float:right;"})
      elsif g.state == "wait"
        info = content_tag(:span, "等待同意", {class: "label label-info", style: "float:right;"})
      else
        info = content_tag(:a, "共享", {class: "btn btn-default btn-xs", style: "float:right;"}) +
        content_tag(:span, "被忽略", {class: "label label-info", style: "float:right;"})
      end
      content_tag(:span, User.find(g.to_id).username) + info
    end
  end

  def ask_user_state(group)
    if group.state == "wait"
      content_tag(:span, "等待同意", { class: "label label-info", style: "float:right;"})
    elsif group.state == "refuse"
      #link_to "再请求", ask_group_user_path(user), remote: true, method: :get, class: "btn btn-default btn-xs", style: "float:right;"
      content_tag(:span, "被拒", { class: "label label-danger", style: "float:right;"})
    else
      content_tag(:span, "$_$", { class: "label label-warn", style: "float:right;"})
    end
  end

end
