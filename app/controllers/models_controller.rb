class ModelsController < ApplicationController
	#protect_from_forgery except: :metadata
	def get_thresholds
		begin
			@continuous_t = Model.get_continous_model(params[:species_id])
			@thresholds = Model.get_thresholds(params[:species_id])

			if @thresholds
				@thresholds.each do |t|
					case t.threshold
					  when "0"
					    @zero_t = t
					  when "10"
					    @ten_t = t
					  when "20"
					  	@twenty_t = t
					  when "30"
					    @thirty_t = t
					end
				end
	    	end

		    respond_to do |format|
		      	format.js
		    end
		rescue => e
			logger.error "#{e.message} #{e.backtrace}"
			err_msg = e.message.tr(?',?").delete("\n")
			render :js => "alertify.alert('Se ha producido un error al consultar los umbrales. #{err_msg}');"
		end
	end

	def get_models
		@ratings = Hash.new

		begin
			@models = Model.get_approved_models(params[:species_id])

			if user_signed_in?
				@models.each do |m|
	          		@rating = Rating.where(model_id: m.modelID, user_id: current_user.id).first
	          		@ratings[m.modelID] = @rating.blank? ? 0 : @rating.score
	        	end
	        end

			respond_to do |format|
		      format.js
		    end
		rescue => e
			logger.error "#{e.message} #{e.backtrace}"
			err_msg = e.message.tr(?',?").delete("\n")
			render :js => "alertify.alert('Se ha producido un error al consultar los modelos. #{err_msg}');"
		end
		
	end

	def metadata
		begin
			@metadata = Model.get_metadata(params[:id])
			@species_name = Species.find_name(@metadata[0]["taxID"])
			@records_number = Species.records_number(@metadata[0]["taxID"])
		rescue => e
			logger.error "#{e.message} #{e.backtrace}"
			err_msg = e.message.tr(?',?").delete("\n")
			render :js => "alertify.alert('Se ha producido un error al obtener los metadatos del modelo.  #{err_msg}');"
		end
	end

	def download_model
	    respond_to do |format|
	      #format.js {}
	      format.html { send_file Rails.root.join("public" + params[:zip_url]), :type => 'application/zip', :disposition => 'attachment' }
	    end
  	end

end