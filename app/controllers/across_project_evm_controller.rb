require "evm_creator"

# controller
class AcrossProjectEvmController < ApplicationController
  include EvmCreator

  def index
    @basis_date = default_basis_date
    @projects_evm = evm_create @basis_date
  end

  private

  def default_basis_date
    params[:basis_date].nil? ? Time.current.to_date : params[:basis_date].to_date
  end
end
