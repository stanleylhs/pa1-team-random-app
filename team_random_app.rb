require "sinatra"
require "sinatra/reloader"


get "/" do
  # Long form to short form 
  # erb(:index, {layout: :application})
  # erb :index, {layout: :application}
  erb :index, layout: :application
end

post "/" do
  # shuffle
  names = params[:names].split(/\s*,\s*/) 
  @result = names[rand(names.length)]
  @teams = []
  @number = params[:number].to_f
  @method = params[:method].to_i
  if @method == 0
    num_in_team = @number.to_i
  elsif @method == 1
    # if number > 
    num_in_team = (names.length / @number).ceil
  end

  until names.empty?
    temp_team = []
    until (temp_team.length == num_in_team) || names.empty?
      rand_no = rand(names.length)
      temp_team << names[rand_no]
      names.delete(names[rand_no])
    end
    @teams << temp_team
  end
  erb :index, layout: :application
end