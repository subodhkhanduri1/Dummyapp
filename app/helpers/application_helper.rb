module ApplicationHelper

  def post_new_user
    '/user/1/new'
  end

  def create_user
    '/user/create'
  end

  def logout_user
    '/user/destroy'
  end

  def user_index_path
    '/user'
  end

  def edit_user_path(id)
    "/user/#{id}/edit"
  end

  def user_path(id)
    "/user/#{id}"
  end
end
