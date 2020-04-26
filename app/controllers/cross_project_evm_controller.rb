# EVM controller.
# This controller provide main evm view.
#
# 1. before action (override)
# 2. selectable list for baseline
# 3. calculate EVM all projects include desendant
# 4. incomplete issues
# 5. export to CSV
#
class CrossProjectEvmController < ApplicationController
  include IssueDataFetcher2
  include CalculateEvmLogic2

  def index
    @projects_evm = {}
    selected_projects = Project.all
    Rails.logger.info("selected_projects: #{selected_projects}")
    selected_projects.each do |proj|
      issues = evm_issues proj.id
      issues_costs = evm_costs proj.id
      @projects_evm[proj.id] = CalculateEvm2.new Time.current.to_date, issues, issues_costs
      @projects_evm[proj.id].description = proj.name
    end
  end
end
