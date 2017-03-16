module ReferablesHelper

  def generate_relations_dropdown
    <<-EOS
    <option disabled selected value>Seleccione...</option>
    <option value="Person">Personas</option>
    <option value="Position">Posiciones</option>
    <option value="Document">Documentos</option>
    <option value="Minute">Actas</option>
    <option value="Task">Tareas</option>
    <option value="ManagementReview">Revisión Gerencial</option>
    <option value="Audit">Auditoría</option>
    <option value="Objective">Objetivos</option>
    <option value="Indicator">Indicadores</option>
    <option value="Risk">Riesgos</option>
    <option value="Swot">FODA</option>
    <option value="Standard">Normas</option>
    <option value="Definition">Definiciones</option>
    EOS
  end

  def class_as_key(class_type)
    class_type.name.underscore.pluralize.to_sym
  end
end