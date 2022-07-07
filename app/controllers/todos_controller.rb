class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /todos or /todos.json
  def index
    @todos = Todo.where(completed: false, user: current_user)
    @completed_todos = Todo.where(completed: true, user: current_user)
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
    if @todo.user != current_user
      respond_to do |format|
        format.html { redirect_to todos_path }
      end
    end
  end

  # GEt /todos/1
  def show
    respond_to do |format|
      format.html { redirect_to todos_path }
    end
  end

  # POST /todos or /todos.json
  def create
    params = todo_params.merge({"user" => current_user, "completed" => false});
    @todo = Todo.new(params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path, notice: "Successfuly Created Todo: " + @todo.title }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    if @todo.user == current_user
      params = todo_params.merge({"user" => current_user});

      respond_to do |format|
        if @todo.update(params)
          format.html { redirect_to todos_path, notice: "Successfully Updated Todo: " + @todo.title }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @todo.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    if @todo.user == current_user
      @todo.destroy

      respond_to do |format|
        format.html { redirect_to todos_url, notice: "Succesfully Deleted Todo: " + @todo.title }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to todos_url }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:title, :body, :completed, :user)
    end
end
