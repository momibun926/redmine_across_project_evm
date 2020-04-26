# parent issue helper
module CrossProjectEvmHelper

  def project_link(proj_id)
    proj = Project.find(proj_id)
    link_to(proj.name, project_path(proj))
  end
end