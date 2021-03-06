module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def sent_requests(id)
    Friendship.exists?(user_id: current_user.id,
                       friend_id: id) || Friendship.exists?(user_id: id, friend_id: current_user.id)
  end

  def current_user_requests(id)
    current_user.friendships.exists?(friend_id: id)
  end

  def pending_requests(id)
    request = current_user.friends.find_by(user_id: id)

    request.nil? ? true : false
  end

  def pending_invitations
    Friendship.where(friend_id: current_user.id).map { |friend| friend.user unless friend.status }.compact
  end
end
