class PersonEvaluationLoader
  attr_accessor :evaluated_person, :evaluated_group, :qualification_type

  def initialize(person_klass, group_klass, params)
    @evaluated_person = person_klass.find(params[:person_id])
    @evaluated_group = group_klass.find(params[:group_id])
    @qualification_type = parse_evaluation_type(params[:qualification_type])
  end

  private

  def parse_evaluation_type(type)
    if type == 'competencias'
      1
    elsif type == 'performance'
      2
    end
  end
end