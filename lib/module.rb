Module.module_eval do
  # Takes a
  def q_const_get(name)
    match = name.match(/^([\w\d_]+)::(.*)/)
    unless match
      const_get(name)
    else
      const_get(match[1]).q_const_get(match[2])
    end
  end
end