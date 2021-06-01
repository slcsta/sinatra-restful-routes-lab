require 'pry'
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end
  get '/' do
    redirect to '/recipes' #redirect to homepage/index
  end

  get '/recipes' do 
    @recipes = Recipe.all #index action access to all recipes thru @recipes instance variable 
    erb :index
  end

  # render a form to create a new recipe
  # this controller action should create and save this new recipe to the database

  get '/recipes/new' do
    #loads the form to create a new recipe
    erb :new #renders form to create new recipe
  end

  post '/recipes' do
    #create action responds to a post request and creates a new recipe based on the 
    #params from the form and saves it to the database
    @recipe = Recipe.create(:name => params[:name], :ingredients => params[:ingredients], :cook_time => params[:cook_time])
    redirect to "/recipes/#{@recipe.id}" 
  end

  #create a controller action using RESTful routes to display a single recipe
  get '/recipes/:id' do
    @recipe = Recipe.find_by_id(params[:id]) #accesss the id of the recipe thru params hash
    erb :show
  end

  #create a third controller action that renders a form to edit a single recipe
  #action should update teh entry in the database w/changes then redirect to the 
  #recipe show page
  get '/recipes/:id/edit' do #load edit form
    @recipe = Recipe.find_by_id(params[:id])
    erb :edit
  end

  patch '/recipes/:id' do #edit the action
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.name = params[:name]
    @recipe.ingredients = params[:ingredients]
    @recipe.cook_time = params[:cook_time]
    @recipe.save
    
    redirect to "/recipes/#{@recipe.id}"
  end

  delete '/recipes/:id' do # delete action
    @recipe = Recipe.find_by_id(params[:id])
    @recipe.delete
    redirect to '/recipes'
  end
end
