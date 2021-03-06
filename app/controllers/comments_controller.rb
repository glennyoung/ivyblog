class CommentsController < ApplicationController

  before_action(:authenticate_user, {except: [:index, :show]})

  before_action(:find_comment, {only: [:edit, :update, :destroy, :show]})

  before_action(:authorize, {only: [:edit, :update, :destroy]})

  def create
    @post = Post.find params[:post_id]

    # associates the post with the user
    # @post.user_id = current_user

    # [IMPROVE] check if there's a need to create global variable here
    comment_params = params.require(:comment).permit(:body)
    @comment = Comment.new(comment_params)

    # associates the comment with the post
    @comment.post = @post
    # @comment.user = current_user.id # this will generate error
    # @comment.user_id = current_user # this will not update user_id
    # @comment.user_id = current_user.id # this will update user_id
    @comment.user = current_user

    # ajaxifying comment
    respond_to do |format|
    # check if successful db query
      if @comment.save
        # this is for mailer trigger, that a new comment is created
        BlogMailer.notify_blog_owner(@comment).deliver_later
        format.html { redirect_to post_path(@post), notice: "Comment created successfully!" }
        format.js   { render :comment_success }
      else
        format.html { render "posts/show" }
        format.js   { render }
      end
    end # end of ajax
  end # end of create action method

  def edit
    # calls before action callback find_comment
  end

  def update
    # calls before action callback find_comment
    if @comment.update(comment_params)
      # redirect_to post_path(@comment.post_id)
      redirect_to post_path(params[:post_id])
    else
      render :edit
    end
  end

  def destroy
    # ajaxifying comment
    respond_to do |format|
      # calls before action callback find_comment
      if @comment.destroy
        # flash[:notice] = "Comment deleted successfully."
        format.html { redirect_to post_path(params[:post_id]) }
        format.js   { render :delete_comment }
      else
        flash[:alert] = "Error in comment delete."
        format.html { redirect_to post_path(params[:post_id]) }
        format.js   { render }
      end
    end
  end

  def show
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
    @post = Post.find(params[:post_id])
  end

  def comment_params
    comment_params = params.require(:comment).permit(:body)
  end

  def authorize
    redirect_to root_path, alert: "Access denied!" unless can? :manage, @comment
  end
end
