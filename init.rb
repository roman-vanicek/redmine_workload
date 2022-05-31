# frozen_string_literal: true

require 'redmine'
require_dependency 'redmine_workload'

Redmine::Plugin.register :redmine_workload do
  name 'Redmine workload plugin'
  author 'Jost Baron, Liane Hampe'
  description 'This is a plugin for Redmine, originally developed by Rafael Calleja. It ' \
              'displays the estimated number of hours users and groups have to work to finish ' \
              'all their assigned issus on time.'
  version '2.0.0'
  url 'https://github.com/JostBaron/redmine_workload'
  author_url 'http://netzkönig.de/'

  menu :top_menu,
       :WorkLoad,
       { controller: 'workloads', action: 'index' },
       caption: :workload_title,
       if: proc {
             User.current.logged? && User.current.allowed_to?({ controller: :workloads, action: :index },
                                                              nil, global: true)
           }

  settings partial: 'settings/workload_settings',
           default: {
             'general_workday_monday' => 'checked',
             'general_workday_tuesday' => 'checked',
             'general_workday_wednesday' => 'checked',
             'general_workday_thursday' => 'checked',
             'general_workday_friday' => 'checked',
             'general_workday_saturday' => '',
             'general_workday_sunday' => '',
             'threshold_lowload_min' => 0.1,
             'threshold_normalload_min' => 7,
             'threshold_highload_min' => 8.5
           }

  permission :view_all_workloads, workloads: :index
  permission :view_own_workloads, workloads: :index
  permission :view_own_group_workloads, workloads: :index
  permission :edit_national_holiday, wl_national_holiday: %i[create update destroy]
  permission :edit_user_vacations,   wl_user_vacations: %i[create update destroy]
  permission :edit_user_data,        wl_user_datas: :update
end

plugin = Redmine::Plugin.find(:redmine_workload)
Rails.application.configure do
  config.autoload_paths << "#{plugin.directory}/app/presenters"
end

class RedmineToolbarHookListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(_context)
    javascript_include_tag('slides', plugin: :redmine_workload) +
      stylesheet_link_tag('style', plugin: :redmine_workload)
  end
end
