require "sinatra"
require "sinatra/reloader"

enable :sessions


get "/" do
  # Long form to short form 
  # erb(:index, {layout: :application})
  # erb :index, {layout: :application}
  erb :index, layout: :application
end

post "/" do
  # shuffle and each_slice
  session[:names] = params[:names]
  session[:number] = params[:number]
  session[:method] = params[:method]
  names = params[:names].split(/\s*,\s*/) 
  # p names.length
  @result = names[rand(names.length)]
  @teams = []
  @number = params[:number].to_i
  @method = params[:method].to_i
  if @method == 0
    if @number > names.length
      message = "Error, the number of people in a team is larger than to people in the list"
      #break
    else
      num_in_team = @number
    end
  elsif @method == 1
    if @number > names.length
      message = "Error, the number of teams is larger than to people in the list"
      #break
    else
      num_in_team = (names.length / @number.to_f).floor
    end
  end

  if message
    @teams = message
  else
    until names.empty?
      temp_team = []
      until (temp_team.length == num_in_team) || names.empty?
        rand_no = rand(names.length)
        temp_team << names[rand_no]
        names.delete(names[rand_no])
      end
      @teams << temp_team
      if @method == 1 && @teams.length >= @number
        i = 0
        until names.empty?
          rand_no = rand(names.length)
          @teams[i] << names[rand_no]
          names.delete(names[rand_no])
          i += 1
        end
      end
    end
  end
  erb :index, layout: :application
end