class LikesController < ApplicationController
    
    def create  
        
            @like = current_user.likes.build(like_params)
            if !@like.save
                flash[:notice] = @like.errros.full_messages.to_sentences 
            end

            # redirect_to @like.post
            redirect_to request.referrer



    end


    def  destroy  

        @like = current_user.likes.find(params[:id])
        post = @like.post  
        @like.destroy  
        redirect_to request.referrer

    end

    private
    def like_params
            params.require(:like).permit(:post_id)
    end



end
