require "evm_creator"
require "csv_data_creator"

# controller
class AcrossProjectEvmController < ApplicationController
  include EvmCreator
  include CsvDataCreator

  def index
    @basis_date = default_basis_date
    @working_hours_per_day = default_working_hours
    @selected_status = default_project_status
    @projects_evm = create_project_evm @basis_date, @selected_status
    respond_to do |format|
      format.html
      format.csv do
        send_data create_csv(@basis_date, @projects_evm, @working_hours_per_day),
                  type: "text/csv; header=present",
                  filename: "evm_#{@basis_date}.csv"
      end
    end
  end

  private

  def default_basis_date
    params[:basis_date].nil? ? Time.current.to_date : params[:basis_date].to_date
  end

  def default_working_hours
    hour = params[:working_hours_per_day].blank? ? 1.0 : params[:working_hours_per_day].to_f
    (7.0..8.0).cover?(hour) ? hour : 1.0
  end

  def default_project_status
    params[:selected_status] || Project::STATUS_ACTIVE
  end
end
