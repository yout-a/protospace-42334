class PrototypesController < ApplicationController
  before_action :set_prototype, only: %i[show edit update destroy]
  before_action :move_to_index, only: %i[edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  # GET /prototypes
  def index
    @prototypes = Prototype.includes(:user).all
  end

  # GET /prototypes/:id
  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  # GET /prototypes/new
  def new
    @prototype = current_user.prototypes.build
  end

  # POST /prototypes
  def create
    @prototype = current_user.prototypes.build(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: "プロトタイプを作成しました"
    else
      render :new
    end
  end

  # GET /prototypes/:id/edit
  def edit
    # 投稿者のみ許可（move_to_indexで制御）
  end

  # PATCH/PUT /prototypes/:id
  def update
    if @prototype.update(prototype_params)
      redirect_to @prototype, notice: "プロトタイプを更新しました"
    else
      render :edit
    end
  end

  # DELETE /prototypes/:id
  def destroy
    @prototype.destroy
    redirect_to prototypes_path, notice: "プロトタイプを削除しました"
  end

  private

  # 投稿データの取得
  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  # ログインしていなければ一覧ページへ
  def check_user_authentication
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  # 投稿者でなければトップページへ
  def move_to_index
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end

  # ストロングパラメータ
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image)
  end
end
