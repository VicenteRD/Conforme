class RisksController < ApplicationController

  def operational
    @risks = Risk::Operational.all

    render 'risks/operational/index', layout: 'table'
  end

  def environment

  end

  def safety

  end

  def standards

  end

  def laws

  end

  def show
    @risk = Risk.find(params[:id])
    if @risk != nil
      if @risk._type == 'Risk::Operational'
        render 'risks/operational/show'
      end
    end
  end

  def new

  end
end
