require "calculate_pv2"
require "calculate_ev2"
require "calculate_ac2"

# Calculation EVM module
module CalculateEvmLogic2
  # Calculation EVM class.
  # Calculate EVM and create data for chart
  class CalculateEvm2
    # Basis date
    attr_reader :basis_date
    # calculation PV class ojbject, basis
    attr_reader :pv
    # calculation EV class ojbject
    attr_reader :ev
    # calculation AC class ojbject
    attr_reader :ac
    # project name
    attr_accessor :project_name
    # project status
    attr_accessor :project_status

    # Constractor
    #
    def initialize(basis_date, issues, costs)
      # EV
      @ev = CalculateEvmLogic2::CalculateEv2.new basis_date, issues
      # AC
      @ac = CalculateEvmLogic2::CalculateAc2.new basis_date, costs
      # PV
      @pv = CalculateEvmLogic2::CalculatePv2.new basis_date, issues
    end

    # Badget at completion.
    # Total hours of issues.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] BAC
    def bac(hours = 1)
      bac = @pv.bac / hours
      bac.round(1)
    end

    # CompleteEV
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] EV / BAC
    def complete_ev(hours = 1)
      complete_ev = bac(hours).zero? ? 0.0 : (today_ev(hours) / bac(hours)) * 100.0
      complete_ev.round(1)
    end

    # Planed value
    # The work scheduled to be completed by a specified date.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] PV on basis date
    def today_pv(hours = 1)
      pv = @pv.today_value / hours
      pv.round(1)
    end

    # Earned value
    # The work actually completed by the specified date;.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] EV on basis date
    def today_ev(hours = 1)
      ev = @ev.today_value / hours
      ev.round(1)
    end

    # Actual cost
    # The costs actually incurred for the work completed by the specified date.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] AC on basis date
    def today_ac(hours = 1)
      ac = @ac.today_value / hours
      ac.round(1)
    end

    # Scedule variance
    # How much ahead or behind the schedule a project is running.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] EV - PV on basis date
    def today_sv(hours = 1)
      sv = today_ev(hours) - today_pv(hours)
      sv.round(1)
    end

    # Cost variance
    # Cost Variance (CV) is a very important factor to measure project performance.
    # CV indicates how much over - or under-budget the project is.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] EV - AC on basis date
    def today_cv(hours = 1)
      cv = today_ev(hours) - today_ac(hours)
      cv.round(1)
    end

    # Schedule Performance Indicator
    # Schedule Performance Indicator (SPI) is an index showing
    # the efficiency of the time utilized on the project.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] EV / PV on basis date
    def today_spi(hours = 1)
      spi = if today_ev(hours).zero? || today_pv(hours).zero?
              0.0
            else
              today_ev(hours) / today_pv(hours)
            end
      spi.round(2)
    end

    # Cost Performance Indicator
    # Cost Performance Indicator (CPI) is an index showing
    # the efficiency of the utilization of the resources on the project.
    #
    # @param [Numeric] hours hours per day
    # @return [Numeric] EV / AC on basis date
    def today_cpi(hours = 1)
      cpi = if today_ev(hours).zero? || today_ac(hours).zero?
              0.0
            else
              today_ev(hours) / today_ac(hours)
            end
      cpi.round(2)
    end
  end
end
