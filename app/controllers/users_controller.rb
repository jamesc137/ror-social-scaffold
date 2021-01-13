class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where('id != ?', current_user.id).order('name ASC')
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def invite
    invitation = current_user.friendships.build(friend_id: params[:user_id])
    if User.check_request(current_user, params[:user_id])
      flash.notice = 'You already have pending Invitations'
      redirect_to users_path
    elsif invitation.save
      redirect_to users_path, notice: 'Your request has been sent!'
    end
  end

  def accept
    request = Friendship.find_by(user_id: params[:user_id], friend_id: current_user.id)
    request.status = true
    request.save
    redirect_to user_path(current_user), notice: "Request Accepted Successfully"
  end

  def reject
    request = Friendship.find_by(user_id: params[:user_id], friend_id: current_user.id)
    request.destroy

    redirect_to users_path, notice: 'Request has been declined'
  end
end
