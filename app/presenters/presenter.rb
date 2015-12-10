class Presenter
  def initialize(object)
    @object = object
  end

  def as_json
    raise NotImplementedError
  end

  private

  def o
    @object
  end
end

