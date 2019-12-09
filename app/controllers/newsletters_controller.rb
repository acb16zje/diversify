class NewslettersController < ApplicationController

    layout 'metrics_page'

    def index
        @newsletters = Newsletter.all 
    end

    def new
        @newsletter = Newsletter.new
    end

    def create
        @newsletter = Newsletter.new(newsletter_params)

        if @newsletter.save
            print (@newsletter)
        end
    end

    def newsletter_params
        params.require(:newsletter).permit(:title, :content)
    end
  
end
