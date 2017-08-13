class CommentsController < ApplicationController
  # コメントを保存、投稿するためのアクションです。
  def create
    @comment = current_user.comments.build(comment_params)
    @blog = @comment.blog
    @notification = @comment.notifications.build(user_id: @blog.user.id )
    
     respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_path(@blog), notice: 'コメントを投稿しました。' }
        format.js { render :index }
        Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'comment_created', {
          message: 'あなたの作成したブログにコメントが付きました1'
        })
        unless @comment.blog.user_id == current_user.id
          Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'comment_created', {
            message: 'あなたの作成したブログにコメントが付きました2'
          })
        end
          Pusher.trigger("user_#{@comment.blog.user_id}_channel", 'notification_created', {
           unread_counts: Notification.where(user_id: @comment.blog.user.id, read: false).count
          })
      else
        format.html { render :new }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @blog = @comment.blog
    respond_to do |format|
     @comment.destroy
     format.html { redirect_to blog_path(@blog) }
      flash.now[:notice] = "コメントが削除されました!"
     format.js { render :index }
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  private
    # ストロングパラメーター
    def comment_params
      params.require(:comment).permit(:blog_id, :content)
    end
end