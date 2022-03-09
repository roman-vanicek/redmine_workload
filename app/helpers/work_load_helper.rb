# frozen_string_literal: true

module WorkLoadHelper
  def is_workload_admin
    right = (Setting.plugin_redmine_workload['allowed_users'].present? && Setting.plugin_redmine_workload['allowed_users'].include?(User.current.id.to_s))
  end

  def render_action_links
    links = []

    links << link_to(l(:workload_title), controller: 'work_load', action: 'show')

    # if is_workload_admin
    links << link_to(l(:workload_holiday_title), controller: 'wl_national_holiday', action: 'index')
    # end

    # if User.current.allowed_to_globally?(:edit_user_data)
    links << link_to(l(:workload_user_data_title), controller: 'wl_user_datas', action: 'show')
    # end

    # if User.current.allowed_to_globally?(:edit_user_vacations)
    links << link_to(l(:workload_user_vacation_menu), controller: 'wl_user_vacations', action: 'index')
    # end

    links.join(' | ').html_safe
  end
end
