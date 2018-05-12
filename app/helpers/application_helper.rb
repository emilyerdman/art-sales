module ApplicationHelper

def form_errors(object=nil)
  render('shared/errors', object: object) unless object.blank?
end

end
