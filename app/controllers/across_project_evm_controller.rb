require "calculate_evm_logic2"
require "data_fetcher"

# controller
class AcrossProjectEvmController < ApplicationController
  include DataFetcher
  include CalculateEvmLogic2

  def index
    @basis_date = default_basis_date
    @projects_evm = {}
    target_project_id_name = project_ids_in_member User.current.id
    target_project_id_name.each do |proj_id|
      issues = evm_issues proj_id
      issues_costs = evm_costs proj_id
      @projects_evm[proj_id] = CalculateEvmLogic2::CalculateEvm2.new @basis_date, issues, issues_costs
    end
  end

  private

  def default_basis_date
    params[:basis_date].nil? ? Time.current.to_date : params[:basis_date].to_date
  end
end
