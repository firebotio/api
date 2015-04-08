ApplicationController.class_eval do
  def dependencies
    Payload::RailsLoader.load
  end
end
