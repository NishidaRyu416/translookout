class DocumentsController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :destroy]

  def new
    @document=Document.new
  end

  def create
    @document=Document.new(document_params)
    if @document.save
      redirect_to @document
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @document.update(document_params)
      redirect_to @document
    else
      render 'edit'
    end
  end

  def destroy
    @document.destroy
  end
  def index
    @documents=Document.all
  end
  def show
  end

  private

  def document_params
    params.require(:document).permit(:title, :body)
  end

  def set_params
    @document = Document.find(params[:id])
  end
end
