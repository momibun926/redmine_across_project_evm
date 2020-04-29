require "evm_creator"

# controller
class AcrossProjectEvmController < ApplicationController
  include EvmCreator

  def index
    @basis_date = default_basis_date
    @working_hours_per_day = default_work_hour
    @selected_status = params[:selected_status] || Project::STATUS_ACTIVE
    @projects_evm = evm_create @basis_date, @selected_status
  end

  private

  def default_basis_date
    params[:basis_date].nil? ? Time.current.to_date : params[:basis_date].to_date
  end

  def default_work_hour
    hour = params[:working_hours_per_day].blank? ? 1.0 : params[:working_hours_per_day].to_f
    (7.0..8.0).cover?(hour) ? hour : 1.0
  end
end
