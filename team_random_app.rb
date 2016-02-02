require "sinatra"
require "sinatra/reloader"

enable :sessions

def team_random(names, number, method)
  teams = [] 
  message = "Error, a number is not entered or it is zero." if number == 0
  if number > names.length
    message ||= "Error, the number of people in a team is larger than to people in the list" if method == 0 
    message ||= "Error, the number of teams is larger than to people in the list" if method == 1
  end

  if message
    teams = message
  else
    if method == 0
      # equal case
      if number == names.length   
        number = 1
      # half case 
      elsif number >= names.length/2 || number-1 >= names.length/2
        number = 2
      # cal num of team
      else  
        number = (names.length/number.to_f).ceil
      end
    end
    num_in_team = (names.length / number.to_f).floor
    until names.empty?
      temp_team = []
      until (temp_team.length == num_in_team) || names.empty?
        rand_no = rand(names.length)
        temp_team << names[rand_no]
        names.delete(names[rand_no])
      end
      teams << temp_team
      if teams.length >= number
        i = 0
        until names.empty?
          rand_no = rand(names.length)
          teams[i] << names[rand_no]
          names.delete(names[rand_no])
          i += 1
        end
      end
    end
  end
  teams
end

get "/" do
  # Long form to short form 
  # erb(:index, {layout: :application})
  # erb :index, {layout: :application}
  erb :index, layout: :application
end

post "/" do
  # shuffle and each_slice
  session[:teams] = nil
  session[:names] = params[:names]
  session[:number] = params[:number]
  session[:method] = params[:method]
  names = params[:names].split(/\s*,\s*/) 
  # p names.length
  session[:result] = names[rand(names.length)]
  # if session[:teams].empty?
  number = params[:number].to_i
  method = params[:method].to_i
  
  session[:teams] = team_random(names,number,method)
  erb :index, layout: :application
end