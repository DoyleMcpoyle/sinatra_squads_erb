require 'sinatra'
require 'shotgun'
require 'pry'
require 'pg'

set :conn, PG.connect(dbname: 'homework1')

before do 
  @conn = settings.conn
end

get '/' do 
  redirect '/squads'
end

# INDEX

get '/squads' do #this route should take the user to a page that shows all of the squads
  squads = []
  @conn.exec("SELECT * FROM squads") do |result|
    result.each do |squad|
    squads << squad 
      end
    end
    @squads = squads  # Usually needed once for index.erb file or to use in any other view file.
    erb :index
  end

# CREATE NEW SQUAD PAGE

get '/squads/new' do #this route should take the user to a page with a form that allows them to create a new squad
erb :new_squads
end

# SHOW INFO ABOUT SQUAD PAGE

get '/squads/:id' do #this route should take the user to a page that shows information about a single squad
    id = params[:id].to_i
    squad = @conn.exec("SELECT * FROM squads WHERE id=$1",[id])
    @squad = squad[0]
    # TAKE THAT SQL SET IT TO @student
    erb :show_squads
  end

# EDIT SQUAD PAGE

            # squad_id/edit
get '/squads/:id/edit' do # this route should take the user to a page with a form that allows them to edit an existing squad
  id = params[:id].to_i
  squad = @conn.exec("SELECT * FROM squads WHERE id=($1)", [id]) 
  @squad = squad[0]         # $1 is used as a place holder. You can have ($1, $2,): (name, id)
  erb :edit_squads
  end

# SHOW STUDENTS PER SQUAD PAGE

get '/squads/:squad_id/students' do # this route should take the user to a page that shows all of the students for an individual squad
 "Hello World"
  # squad_id = params[:squad_id].to_i # CODE break!
  # students = []
  # @conn.exec("SELECT * FROM students WHERE squad_id= $1", [params[:squad_id]]) do |result|
  # result.each do |student|
  # students << student
  # end
end
# @students = students

# squad = @conn.exec("SELECT * FROM squads WHERE id = $1", [params[:squad_id]])
#   @squad = squad[0]
#   erb :show_students
#   # end

# SHOW STUDENT INFO IN A SQUAD PAGE

get 'squads/:squad_id/students/:student_id' do # this route should take the user to a page that shows information about an individual student in a squad
id = params[:student_id].to_i
student = @conn.exec('SELECT * FROM students WHERE id = $1', [ id ])
@student = student[0]
erb :show_students
end


# TAKES TO CREATE NEW STUDENT PAGE

get '/squads/:squad_id/students/new' do # this route should take the user to a page that shows them a form to create a new student
  @squad_id = params[:squad_id].to_i
  erb :new_students
  end

get '/squads/:squad_id/students/:student_id/edit' do # this route should take the user to a page that shows them a form to edit a student's information
id = params[:student_id].to_i
student = @conn.exec("SELECT * FROM students WHERE id = $1", [id])
@student = student[0]
erb :edit_students
end

##################################################

# CREATE NEW SQUAD

post '/squads' do # this route should be used for creating a new squad
  name = params[:name]
  mascot = params[:mascot]
  @conn.exec("INSERT INTO squads (name, mascot) VALUES ($1,$2)",[name,mascot])
  redirect '/squads'
  end

post '/squads/:squad_id/students' do # this route should be used for creating a new student in an existing squad
redirect '/squads'
end

##################################################

# UPDATE A SQUAD

put '/squads/:id' do # this route should be used for editing an existing squad
  id = params[:id].to_i
  squad_name = params[:name]
  squad_mascot = params[:mascot]
  @conn.exec("UPDATE squad SET name = $1 WHERE id = $2", [squad_name, id])
  @conn.exec("UPDATE squad SET mascot = $1 WHERE id = $2", [squad_mascot, id])
  redirect '/'
end

put '/squads/:squad_id/students' do # this route should be used for editing an existing student in a squad
  end

##################################################

delete '/squads' do # this route should be used for deleting an existing squad
squad_id = params[:student_id].to_i
@conn.exec("DELETE FROM squads WHERE squad_id =$1", [squad_id])
redirect '/squads'
end

delete '/squads/:squad_id/students' do # this route should be used for deleting an existing student in a squad
  student_id = params[:student_id].to_i
  @conn.exec("DELETE FROM students WHERE student_id =$1", [student_id])
  id = params[:squad_id].to_i
  redirect '/squads'
  end



