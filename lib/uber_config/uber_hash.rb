class UberHash < Hash

  def [](key)
    r = super[key]
    return r if r
    if r.is_a?(Symbol)
      return super[key.to_s]
    end
    r
  end

end