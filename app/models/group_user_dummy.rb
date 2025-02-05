# frozen_string_literal: true

require 'forwardable'

##
# GroupUserDummy representing a user of a group who holds all issues haven't been assigned
# to a real group member yet.
#
# @note The class name is relevant for sorting GroupUserDummy against User classes
#       in alphabetical order.
#
class GroupUserDummy
  include Redmine::I18n
  extend Forwardable

  def_delegators :group, :id, :firstname, :users

  attr_reader :group

  ##
  # @params group [Group] An instance of Group model.
  #
  def initialize(group:)
    self.group = group
    self.group_members = find_group_members
  end

  def wl_user_data
    nil
  end

  def groups
    [group]
  end

  def lastname
    l(:label_assigned_to_group, value: group.lastname)
  end

  alias name lastname

  def threshold_lowload_min
    sum_up(:threshold_lowload_min)
  end

  def threshold_normalload_min
    sum_up(:threshold_normalload_min)
  end

  def threshold_highload_min
    sum_up(:threshold_highload_min)
  end

  def main_group
    group
  end

  def main_group_id
    group.id
  end

  def type
    'Group'
  end

  private

  attr_writer :group
  attr_accessor :group_members

  def sum_up(attribute)
    return 0.0 unless group_members.presence

    group_members.sum(&attribute.to_sym)
  end

  def find_group_members
    WlUserData.where(user_id: group_member_ids, main_group: id)
  end

  def group_member_ids
    users.map(&:id)
  end
end
