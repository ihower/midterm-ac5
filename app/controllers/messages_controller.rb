class MessagesController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @messages = Message.order("id DESC").page( params[:page] )

    if params[:status] == "pending"
      @messages = @messages.pending
    elsif params[:status] == "completed"
      @messages = @messages.completed
    end

    if params[:days]
      @messages = @messages.within_days(params[:days].to_i)
    end

    @messages = @messages.includes(:comments, :user)
  end

  def show
    @message = Message.find( params[:id] )
    @comment = Comment.new

    @subscribed_users = @message.subscribed_users
    @liked_users = @message.liked_users
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new( message_params )
    @message.user = current_user

    @message.save!

    redirect_to root_path
  end

  def edit
    @message = current_user.messages.find( params[:id] )

    render "new"
  end

  def update
    @message = current_user.messages.find( params[:id] )

    @message.update!( message_params )

    redirect_to message_path(@message)
  end

  def destroy
    @message = current_user.messages.find( params[:id] )
    @message.destroy

    redirect_to root_path
  end

  protected

  def message_params
    params.require(:message).permit(:title, :content, :category_name)
  end

end
