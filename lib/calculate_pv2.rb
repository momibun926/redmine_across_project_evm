require_relative "base_calculate2"

# Calculation EVM module
module CalculateEvmLogic2
  # Calculation PV class.
  # PV calculate estimate hours of issues.
  #
  class CalculatePv2 < CalculateEvmLogic2::BaseCalculateEvm2
    # start date (exclude basis date)
    attr_reader :start_date
    # due date (exclude basis date)
    attr_reader :due_date

    # Constractor
    #
    # @param [date] basis_date basis date.
    # @param [issue] issues for culculation of PV.
    # @param [string] region setting region use calculation working days.
    # @param [string] exclude_holiday setting exclude holiday
    def initialize(basis_date, issues)
      # basis date
      @basis_date = basis_date
      # daily PV
      @daily = calculate_planed_value issues
      # planed start date
      @start_date = @daily.keys.min || @basis_date
      # planed due date
      @due_date = @daily.keys.max || @basis_date
      # basis date
      @daily[@basis_date] ||= 0.0
      # cumulative PV
      @cumulative = create_cumulative_evm @daily
    end

    # Badget at completion (BAC)
    # Total estimate hours of issues.
    #
    # @return [Numeric] BAC
    def bac
      @cumulative.values.max
    end

    # Today"s planed value
    #
    # @return [Numeric] PV on basis date or PV of baseline.
    def today_value
      @cumulative[@basis_date]
    end

    private

    # Calculate PV.
    # if due date is nil , set varsion due date.
    #
    # @note If the due date has not been entered, we will use the due date of the version
    # @param [issue] issues target issues of EVM
    # @return [hash] EVM hash. Key:Date, Value:PV of each days
    def calculate_planed_value(issues)
      temp_pv = {}
      Array(issues).each do |issue|
        issue.due_date ||= Version.find(issue.fixed_version_id).effective_date
        pv_days = working_days issue.start_date, issue.due_date
        hours_per_day = issue_hours_per_day issue.estimated_hours.to_f, pv_days.length
        pv_days.each do |date|
          temp_pv[date] = add_daily_evm_value temp_pv[date], hours_per_day
        end
      end
      temp_pv
    end

    # Estimated time per day.
    #
    # @param [Numeric] estimated_hours estimated hours
    # @param [Numeric] days working days
    def issue_hours_per_day(estimated_hours, days)
      (estimated_hours || 0.0) / days
    end

    # working days.
    # exclude weekends and holiday or include weekends and holiday.
    #
    # @param [date] start_date start date of issue
    # @param [date] end_date end date of issue
    # @return [Array] working days
    def working_days(start_date, end_date)
      (start_date..end_date).to_a
    end
  end
end
