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
  include "IssueDataFetcher"
  # menu
  menu_item :projectevm

  # Before action
  before_action :find_project, :authorize

  def index
    @projects_evm = {}
    selected_projects = Projects.all
    selected_projects.each do |proj|
      issues = evm_issues proj.id
      issues_costs = evm_costs proj.id
      @project_evm[proj.id] = CalculateEvm.new issues, issues_costs
      @project_evm[proj.id].description = proj.name
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
