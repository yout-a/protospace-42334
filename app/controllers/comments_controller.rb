class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @prototype = Prototype.find(params[:prototype_id])
    @comment   = @prototype.comments.build(comment_params)
    if @comment.save
      redirect_to prototype_path(@prototype), notice: "コメントしました"
    else
      # エラー時の再描画など
      @prototype = Prototype.find(params[:prototype_id])
      @comments = @prototype.comments.all
      render "prototypes/show"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
