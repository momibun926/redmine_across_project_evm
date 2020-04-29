# parent issue helper
module AcrossProjectEvmHelper
  # link of target project
  def project_link(proj_id, proj_name)
    link_to(proj_name, project_path(proj_id))
  end

  # unit
  def explanation_of_unit(working_hours_per_day)
    unit = working_hours_per_day == 1.0 ? l(:unit_evm_hours) : l(:unit_evm_days)
    content_tag(:p, unit)
  end
end
