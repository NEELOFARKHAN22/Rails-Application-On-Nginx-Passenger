class CommentsController < ApplicationController
    before_action :set_comment, only: %i[ show edit update destroy ]
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.create(comment_params)
      
      respond_to do |format|
        if @comment.save
          format.html { redirect_to post_path(@post), notice: "Comment was successfully created." }
          # format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new, status: :unprocessable_entity }
          # format.json { render json: @comment.errors, status: :unpr/ocessable_entity }
        end
      end
    end
  
    def destroy
        # debugger

        # @post = Post.find(params[:article_id])
        # @comment = @post.comments.find(params[:id])
        # @comment.destroy
 
      @comment.destroy
  
      respond_to do |format|
        format.html { redirect_to post_path, notice: "Comment was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_comment
        @comment = Comment.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def comment_params
        params.require(:comment).permit(:body, :user_id, :post_id)
      end
  end