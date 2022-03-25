# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class DateToolsTest < ActiveSupport::TestCase
  test 'working_days_in_time_span works if start and end day are equal and no holiday.' do
    # Set friday to be a working day.
    Setting['plugin_redmine_workload']['general_workday_friday'] = 'checked'

    date = Date.new(2005, 12, 30); # A friday
    assert_equal Set.new([date]), DateTools.working_days_in_time_span(date..date, 'all', no_cache: true)
  end

  test 'working_days_in_time_span works if start and end day are equal and a holiday.' do
    # Set friday to be a holiday.
    Setting['plugin_redmine_workload']['general_workday_friday'] = ''

    date = Date.new(2005, 12, 30);      # A friday
    assert_equal Set.new, DateTools.working_days_in_time_span(date..date, 'all', no_cache: true)
  end

  test 'working_days_in_time_span works if start day before end day.' do
    startDate = Date.new(2005, 12, 30); # A friday
    endDate = Date.new(2005, 12, 28);   # A wednesday
    assert_equal Set.new, DateTools.working_days_in_time_span(startDate..endDate, 'all', no_cache: true)
  end

  test 'working_days_in_time_span works if both days follow each other and are holidays.' do
    # Set wednesday and thursday to be a holiday.
    Setting['plugin_redmine_workload']['general_workday_wednesday'] = ''
    Setting['plugin_redmine_workload']['general_workday_thursday'] = ''

    startDate = Date.new(2005, 12, 28); # A wednesday
    endDate = Date.new(2005, 12, 29); # A thursday
    assert_equal Set.new, DateTools.working_days_in_time_span(startDate..endDate, 'all', no_cache: true)
  end

  test 'working_days_in_time_span works if only weekends and mondays are holidays and startday is thursday, endday is tuesday.' do
    # Set saturday, sunday and monday to be a holiday, all others to be a working day.
    Setting['plugin_redmine_workload']['general_workday_monday'] = ''
    Setting['plugin_redmine_workload']['general_workday_tuesday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_wednesday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_thursday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_friday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_saturday'] = ''
    Setting['plugin_redmine_workload']['general_workday_sunday'] = ''

    startDate = Date.new(2005, 12, 29); # A thursday
    endDate = Date.new(2006, 1, 3);     # A tuesday

    expectedResult = [
      startDate,
      Date.new(2005, 12, 30),
      endDate
    ]

    assert_equal Set.new(expectedResult), DateTools.working_days_in_time_span(startDate..endDate, 'all', no_cache: true)
  end

  test 'working_days returns the working days.' do
    # Set saturday, sunday and monday to be a holiday, all others to be a working day.
    Setting['plugin_redmine_workload']['general_workday_monday'] = ''
    Setting['plugin_redmine_workload']['general_workday_tuesday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_wednesday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_thursday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_friday'] = 'checked'
    Setting['plugin_redmine_workload']['general_workday_saturday'] = ''
    Setting['plugin_redmine_workload']['general_workday_sunday'] = ''

    assert_equal Set.new([2, 3, 4, 5]), DateTools.working_days
  end
end
