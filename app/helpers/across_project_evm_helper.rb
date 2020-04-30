# parent issue helper
module AcrossProjectEvmHelper
  # link of target project
  def project_link(proj_id)
    proj = Project.find(proj_id)
    link_to(proj.name, project_path(proj))
  end

  # unit
  def explanation_of_unit(working_hours_per_day)
    unit = working_hours_per_day == 1.0 ? l(:unit_evm_hours) : l(:unit_evm_days)
    content_tag(:p, unit)
  end
end
